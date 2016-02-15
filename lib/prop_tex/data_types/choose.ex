alias PropTex.{DataDescription, DataInstance}
defmodule PropTex.DataTypes.Choose do
  import PropTex.Utils.ShortMaps

  ###    Presets   ###
  def from(choices, opts \\ []) do
    choices = choices
              |> Enum.with_index
              |> Enum.map(fn {v, i} -> {i, v} end)
              |> Enum.into(%{})
    %{preset: :from, choices: choices}
    |> construct_description(opts)
  end

  def from_weighted(choices, opts \\ []) do
    total_weight = choices
                   |> Enum.map(fn {v, w} -> w end)
                   |> Enum.sum
    normalized_choices = choices
                         |> Enum.filter_map(fn {v, w} -> w > 0 end,
                                            fn {v, w} -> {v, w/total_weight} end)
    summed_choices = sum_choices(normalized_choices)
    %{preset: :from_weighted, choices: summed_choices}
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

  def shrinker(_opts), do: &(&1)

  def gen(%{preset: :from, choices: choices}, i) do
    index = Map.values(choices)
    |> length
    |> :rand.uniform
    index = index - 1
    Map.get(choices, index)
    |> DataDescription.create_instance(i)
  end
  def gen(%{preset: :from_weighted, choices: choices}, i) do
    val = :rand.uniform()
    {c, _w} = Enum.find(choices, fn {_c, w} -> val < w end)
    DataDescription.create_instance(c, i)
  end

  def sum_choices(list) do
    do_sum_choices(list, [], 0)
  end
  def do_sum_choices([], acc, _total), do: Enum.reverse(acc)
  def do_sum_choices([{v, w}|t], acc, total) do
    total = total + w
    do_sum_choices(t, [{v, total}|acc], total)
  end

end
