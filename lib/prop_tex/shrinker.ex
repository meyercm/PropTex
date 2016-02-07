alias PropTex.{
  DataInstance,
  RunSpec,
}
defmodule PropTex.Shrinker do
  import PropTex.Utils.ShortMaps
  #API
  def shrink(instance, ~m{%RunSpec check_fun run_options}=run_spec) do
    # add check for max_shrink time, iterations
    case shrink_instance(instance) do
      ^instance -> {:done_max_shrink, instance}
      new_instance ->
        data = DataInstance.eval_instance(new_instance)
        try do
          check_fun.(data)
          {:done_last_fail_value, instance}
        rescue
          _ -> shrink(new_instance, run_spec)
        end
    end
  end

  #internal
  def shrink_instance(~m{%DataInstance value source shrink_info}=prev) do
    new_val = case hd(shrink_info) do
      :unshrinkable -> shrink_instance(value)
      _other -> source.shrink_fun.(prev)
    end
    new_info = case new_val == prev do
      true -> :unshrinkable
      false -> new_val
    end
    %DataInstance{prev|value: new_val, shrink_info: [new_info|shrink_info]}
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
