alias PropTex.{
  DataDescription,
  DataInstance,
  RunSpec,
  Shrinker,
}
defmodule PropTex do
  import PropTex.Utils.ShortMaps

  defmacro for_many({:<-, _, [var, run_spec]}, [do: do_block]) do
    quote  do
      run_spec = unquote(run_spec)
      check_fun = fn(unquote(var)) ->
                    unquote(do_block)
                  end
      run_spec = %RunSpec{run_spec|check_fun: check_fun}
      PropTex.check(run_spec)
    end
  end

  def examples_of(data_description, run_options \\ []) do
    run_options = Enum.into(run_options, %{})
    ~m{%RunSpec data_description run_options}
  end

  def check(~m{%RunSpec run_options data_description check_fun} = run_spec) do
    iterations = Map.get(run_options, :iterations, 100)
    for i <- 1..iterations do
      instance = DataDescription.create_instance(data_description, i)
      data = DataInstance.eval_instance(instance)
      try do
        check_fun.(data)
        {:ok, i}
      rescue
        ex ->
          IO.puts("Failing Instance: #{inspect ~m{data}}")
          Shrinker.shrink(instance, run_spec)
          raise ex
      end
    end
  end

  def run_tests do
    spawn fn ->
      :os.cmd('mix test') |> IO.puts
    end
  end
end
