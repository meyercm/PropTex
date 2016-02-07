alias PropTex.{DataDescription, DataInstance}
defmodule PropTex.DataTypes.Float do
  import PropTex.Utils.ShortMaps
  @min_zero_approach 1.0e-10

  ###    Presets   ###
  def positive(opts \\ []) do
    %{preset: :positive, precision: :unlimited}
    |> construct_description(opts)
  end
  def negative(opts \\ []) do
    %{preset: :negative, precision: :unlimited}
    |> construct_description(opts)
  end
  def any(opts \\ []) do
    %{preset: :any, precision: :unlimited}
    |> construct_description(opts)
  end
  def between(lower, upper, opts \\ []) when lower < upper do
    lower = lower * 1.0 #convert to float
    upper = upper * 1.0 #convert to float
    %{preset: :between, bounds: ~m{lower upper}, precision: :unlimited}
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

  def shrinker(~m{preset precision} = opts) do
    case preset do
      :between ->
        case check_bounds(0, opts.bounds) do
          true -> toward_value_shrinker(0.0, precision)
          false ->
            ~m{lower upper} = opts.bounds
            nearer_zero_bound = case abs(lower) < abs(upper) do
              true -> lower
              false -> upper
            end
            toward_value_shrinker(nearer_zero_bound, precision)
        end
      _other -> toward_value_shrinker(0.0, precision)
    end
  end

  def toward_value_shrinker(destination, precision) do
    fn(~m{%DataInstance value} = instance) ->
      new_val = case abs(value - destination) do
        v when v > @min_zero_approach -> (value + destination) / 2
        _smaller -> destination
      end
      |> set_precision(precision)
      %DataInstance{instance|value: new_val}
    end
  end

  def check_bounds(val, %{lower: lower, upper: _}) when val < lower, do: false
  def check_bounds(val, %{lower: _, upper: upper}) when val > upper, do: false
  def check_bounds(_val, %{lower: _, upper: _}), do: true


  def gen(%{preset: :any}, 0), do: 0.0
  def gen(%{preset: :positive}, 0), do: 1.0
  def gen(%{preset: :negative}, 0), do: -1.0
  def gen(%{preset: :between, bounds: ~m{lower upper}}, 0)
      when lower <= 0 and upper >= 0, do: 0.0
  def gen(%{preset: :between, #alternate start when bounds don't include 0
            bounds: ~m{lower},
            precision: p}, 0), do: lower |> set_precision(p)
  def gen(%{preset: :between,
            bounds: ~m{lower},
            precision: p}, 1), do: lower |> set_precision(p)
  def gen(%{preset: :between,
            bounds: ~m{upper},
            precision: p}, 2), do: upper |> set_precision(p)
  def gen(%{preset: :between, bounds: ~m{lower upper}, precision: p}, _i) do
    :rand.uniform() * (upper - lower) + lower
    |> set_precision(p)
  end
  def gen(%{preset: :any, precision: p}, _i) do
    [r0,r1,r2,r3,r4,r5,r6,r7] = for _ <- 0..7, do: trunc(:rand.uniform() * 256)
    :erlang.binary_to_term(<<131,70,r0,r1,r2,r3,r4,r5,r6,r7>>)
    |> set_precision(p)
  end
  def gen(%{preset: :positive, precision: p}, _i) do
    [r0,r1,r2,r3,r4,r5,r6,r7] = for _ <- 0..7, do: trunc(:rand.uniform() * 256)
    :erlang.binary_to_term(<<131,70,0::1,r0::7,r1,r2,r3,r4,r5,r6,r7>>)
    |> set_precision(p)
  end
  def gen(%{preset: :negative, precision: p}, _i) do
    [r0,r1,r2,r3,r4,r5,r6,r7] = for _ <- 0..7, do: trunc(:rand.uniform() * 256)
    :erlang.binary_to_term(<<131,70,1::1,r0::7,r1,r2,r3,r4,r5,r6,r7>>)
    |> set_precision(p)
  end

  def set_precision(num, :unlimited), do: num
  def set_precision(num, n), do: Float.round(num, n)
end
