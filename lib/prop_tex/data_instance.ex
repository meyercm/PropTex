alias PropTex.DataInstance
defmodule PropTex.DataInstance do
  import PropTex.Utils.ShortMaps
  defstruct [
    value: nil,
    source: nil,
    shrink_info: [],
  ]

  def eval_instance(instance)
  def eval_instance(~m{%DataInstance value}=instance) do
    eval_instance(value)
  end
  def eval_instance(instance) when is_list(instance) do
    Enum.map(instance, &eval_instance/1)
  end
  def eval_instance(instance) when is_map(instance) do
    instance
    |> Enum.map(&eval_instance/1)
    |> Enum.into(%{})
  end
  def eval_instance(instance) when is_tuple(instance) do
    instance
    |> Tuple.to_list
    |> eval_instance
    |> List.to_tuple
  end
  def eval_instance(instance), do: instance
end
