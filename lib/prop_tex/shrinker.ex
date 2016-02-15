alias PropTex.{DataInstance, RunSpec}
defmodule PropTex.Shrinker do
  import PropTex.Utils.ShortMaps
  #API
  def shrink(instance, run_spec) do
    do_shrink(instance, run_spec)
    |> finish_up
  end

  #internal
  def do_shrink(instance, ~m{%RunSpec check_fun run_options}=run_spec) do
    # add check for max_shrink time, iterations
    case shrink_instance(instance) do
      ^instance -> {:done_max_shrink, instance}
      new_instance ->
        data = DataInstance.eval_instance(new_instance)
        try do
          check_fun.(data)
          {:done_passing_again, instance, new_instance}
        rescue
          _ -> do_shrink(new_instance, run_spec)
        end
    end
  end

  # Need to swap the puts for something a bit more professional
  def finish_up({:done_max_shrink, val}) do
    e_val = DataInstance.eval_instance(val)
    IO.puts "failing case shrunk to #{inspect e_val}, in #{length(val.shrink_info)} rounds; cannot shrink further"
  end
  def finish_up({:done_passing_again, fail, pass}) do
    e_fail = DataInstance.eval_instance(fail)
    e_pass = DataInstance.eval_instance(pass)
    IO.puts "failing case shrunk to #{inspect e_fail}, in #{length(fail.shrink_info)} rounds; shrinking further gives #{inspect e_pass}, which passes"
  end



  def shrink_instance(~m{%DataInstance value source shrink_info}=prev) do
    case hd(shrink_info) do
      :unshrinkable -> shrink_instance(value)
      _other ->
        new_val = source.shrink_fun.(prev)
        new_info = case new_val == prev do
          true -> :unshrinkable
          false -> new_val
        end
        %DataInstance{prev|value: new_val, shrink_info: [new_info|shrink_info]}
    end
  end
  def shrink_instance(prev) when is_list(prev) do
    Enum.map(prev, &shrink_instance/1)
  end
  def shrink_instance(prev) when is_map(prev) do
    prev
    |> Enum.map(&shrink_instance/1)
    |> Enum.into(%{})
  end
  def shrink_instance(prev) when is_tuple(prev) do
    prev
    |> Tuple.to_list
    |> shrink_instance
    |> List.to_tuple
  end
  def shrink_instance(prev), do: prev
end
