alias PropTex.{DataDescription, DataInstance}
defmodule PropTex.DataTypes.Integer do
  import PropTex.Utils.ShortMaps

  ###    Presets   ###
  def positive(opts \\ []) do
    %{preset: :positive}
    |> construct_description(opts)
  end
  def negative(opts \\ []) do
    %{preset: :negative}
    |> construct_description(opts)
  end
  def any(opts \\ []) do
    %{preset: :any}
    |> construct_description(opts)
  end
  def between(lower, upper, opts \\ []) when lower <= upper do
    lower = trunc(lower)
    upper = trunc(upper)
    %{preset: :between, bounds: ~m{lower upper}}
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

  def shrinker(~m{preset} = opts) do
    case preset do
      :between ->
        case check_bounds(0, opts.bounds) do
          true -> toward_value_shrinker(0)
          false ->
            ~m{lower upper} = opts.bounds
            nearer_zero_bound = case abs(lower) < abs(upper) do
              true -> lower
              false -> upper
            end
            toward_value_shrinker(nearer_zero_bound)
        end
      _other -> toward_value_shrinker(0)
    end
  end

  def toward_value_shrinker(destination) do
    fn(~m{%DataInstance value} = instance) ->
      new_val = trunc((value + destination) / 2)
      %DataInstance{instance|value: new_val}
    end
  end

  def check_bounds(val, %{lower: lower, upper: _}) when val < lower, do: false
  def check_bounds(val, %{lower: _, upper: upper}) when val > upper, do: false
  def check_bounds(_val, %{lower: _, upper: _}), do: true


  def gen(%{preset: :any}, 0), do: 0
  def gen(%{preset: :positive}, 0), do: 1
  def gen(%{preset: :negative}, 0), do: -1
  def gen(%{preset: :between, bounds: ~m{lower upper}}, 0)
      when lower <= 0 and upper >= 0, do: 0
  def gen(%{preset: :between, #alternate start when bounds don't include 0
            bounds: ~m{lower}}, 0), do: lower
  def gen(%{preset: :between,
            bounds: ~m{lower}}, 1), do: lower
  def gen(%{preset: :between,
            bounds: ~m{upper}}, 2), do: upper
  def gen(%{preset: :between, bounds: ~m{lower upper}}, _i) do
    trunc(:rand.uniform() * (upper - lower) + lower)
  end
  def gen(~m{preset}, i) when i < 1000 do
    :rand.uniform() * :math.pow(2, i) + 1
    |> trunc
    |> update_sign(preset)
  end
  def gen(opts, _i), do: gen(opts, 1000) #2^1000 should be plenty big

  def update_sign(val, :any) do
    sign = :rand.uniform(2) * 2 - 3
    val * sign
  end
  def update_sign(val, :positive), do: val
  def update_sign(val, :negative), do: -val
end
