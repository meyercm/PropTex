alias PropTex.{DataDescription, DataInstance, DataTypes}
defmodule PropTex.DataTypes.List do
  import PropTex.Utils.ShortMaps

  ###    Presets   ###
  def of(prototype, opts \\ []) do
    %{preset: :of, prototype: prototype, length: DataTypes.Integer.between(0, 100)}
    |> construct_description(opts)
  end

  def construct_description(preset_options, manual_options) do
    manual_options = manual_options |> Enum.into(%{})
    data_options = preset_options
                   |> Map.merge(manual_options)
    shrink_fun = shrinker(data_options)
    module = __MODULE__
    ~m{%DataDescription module data_options shrink_fun}
  end

  def generate_instance(~m{%DataDescription data_options} = source, i) do
    value = gen(data_options, i)
    shrink_info = [value]
    ~m{%DataInstance source value shrink_info}
  end

  def shrinker(~m{length} = opts) when is_integer(length) do
    no_shrinker
  end
  def shrinker(~m{length} = opts) do
    head_shrinker(length)
  end

  def no_shrinker do
    &(&1)
  end

  def head_shrinker(length_desc) do
    fn(~m{%DataInstance value} = instance) ->
      #manually shrink the length, if possible;
      old_length = length(value)
      length_i = DataDescription.create_instance(length_desc, 1)
                 |> Map.put(:value, old_length)
      new_length = length_i.source.shrink_fun.(length_i)
                   |> DataInstance.eval_instance
      # now keep that part of the list:
      new_val = Enum.take(value, new_length)
      %DataInstance{instance|value: new_val}
    end
  end

  def gen(%{preset: :of, length: length, prototype: prototype}, i) do
    len = case DataDescription.create_instance(length, i) do
      length when is_integer(length) -> length
      ~m{%DataInstance value} -> value
    end
    case len do
      0 -> []
      _ ->
        for j <- 1..len do
          DataDescription.create_instance(prototype, i)
        end
    end
  end
end
