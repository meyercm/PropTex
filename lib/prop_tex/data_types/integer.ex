# defmodule PropTex.Types.Integer do
#   # TODO: create a range pattern match
#   def between(lower, upper) do
#     gen = fn(_) -> trunc(:rand.uniform() * (upper - lower) + lower) end
#     shrink = default_shrinker(lower)
#     %PropTex.LazyType{gen: gen, shrinkers: [shrink]}
#     |> populate_defaults
#   end
#
#   def positive(upper_bound // :none) do
#
#   end
#
#   def negative(lower_bound //:none) do
#
#   end
#   def above(lower_bound) do
#
#   end
#   def below(upper_bound) do
#
#   end
#   def any do
#
#   end
#
#
#   def digit_gen(digits) do
#
#   end
#   def populate_defaults(%{complexity: :default}=struct) do
#     struct |> Map.put(:complexity, default_complexity)
#   end
#   def populate_defaults(%{simplest: :default}=struct) do
#     struct |> Map.put(:simplest, default_simplest)
#   end
#   def populate_defaults(%{shrinkers: :default}=struct) do
#     struct |> Map.put(:shrinkers, default_shrinkers)
#   end
#   def populate_defaults(struct), do: struct
#
#   def default_complexity, do: fn(i) -> abs(i) end
#   def default_simplest(), do: fn -> 0 end
#   def default_shrinkers(), do: [default_shrinker()]
#   def default_shrinker(lower_bound // 0) do
#     fn
#       (old_fail) -> trunc((old_fail + lower) / 10)
#       (old_fail, old_pass) -> trunc((old_fail + old_pass) / 2)
#     end
#   end
# end
#
#
# alias PropTex.{DataDescription, DataInstance}
# defmodule PropTex.DataTypes.Float do
#   import PropTex.Utils.ShortMaps
#
#   @float_lower -1.79e308
#   @float_upper 1.7976931348623157e+308
#   @float_pos_min -
#   @float_net_min
#   defmodule Options do
#     defstruct [
#       lower: @float_lower,
#       upper: @float_upper,
#       precision: 16,
#     ]
#   end
#   ###    Presets   ###
#   def positive(opts \\ []) do
#     %{lower: @float_pos_min,
#       upper: @float_upper}
#     |> construct_description
#   end
#   def negative(opts \\ []) do
#     %{lower: @float_lower,
#       upper: @float_neg_min}
#     |> construct_description
#   end
#   def any(opts \\ []) do
#     %{lower: @float_lower,
#       upper: @float_upper}
#     |> construct_description(opts)
#   end
#   def between(lower, upper, opts \\ []) do
#     ~m{lower, upper}
#     |> construct_description
#   end
#
#   def construct_description(preset_options, manual_options) do
#     manual_options |> Enum.into()
#     shrink_fun = shrinker(data_options)
#     module = __MODULE__
#     ~m{%DataDescription module data_options shrink_fun}
#   end
#
#   def generate_instance(description) do
#     %DataInstance{
#       source: description,
#       value: gen(opts),
#     }
#   end
#
#   def shrinker(opts) do
#     fn(data_instance) ->
#
#     end
#   end
#
#   def gen(opts)
# end
