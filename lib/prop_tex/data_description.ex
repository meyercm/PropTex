alias PropTex.DataDescription
defmodule PropTex.DataDescription do
  import PropTex.Utils.ShortMaps
  defstruct [
    module: nil,
    data_options: %{},
    shrink_fun: nil,
  ]

  def create_instance(description, i)
  def create_instance(~m{%DataDescription module}=description, i) do
    apply(module, :generate_instance, [description, i])
  end
  def create_instance(~m{__struct__}=description, i) do
    description
    |> Map.delete(:__struct__)
    |> create_instance(i)
    |> Map.put(:__struct__, __struct__)
  end
  def create_instance(description, i) when is_list(description) do
    Enum.map(description, &(create_instance(&1, i)))
  end
  def create_instance(description, i) when is_map(description) do
    description
    |> Enum.map(&(create_instance(&1, i)))
    |> Enum.into(%{})
  end
  def create_instance(description, i) when is_tuple(description) do
    description
    |> Tuple.to_list
    |> create_instance(i)
    |> List.to_tuple
  end
  def create_instance(description, _i), do: description

end
