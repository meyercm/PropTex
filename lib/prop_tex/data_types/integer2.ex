# defmodule LateInteger do
#   ###    API    ####
#   def below(lb), do: {__MODULE__, %{lower: lb}}
#   def below({__MODULE__, opts}, lb)
#   def above(ub), do: {__MODULE__, %{upper: ub}}
#   def between(lb, ub), do: below(ub).above(lb)
#   def between(%Range{first: f, last: l}) when f < l do
#     below(l).above(f)
#   end
#   def between(%Range{first: f, last: l}) do
#     below(f).above(l)
#   end
#
#   ###    CALLBACKS   ####
#
#   def generator(opts) do
#     fn (_prev) ->
#
#     end
#   end
#   def shrinkers(opts) do
#     []
#   end
#   def complexity(item) do
#     abs(item)
#   end
#   def simplest(opts) do
#     0
#   end
#   def special_cases(opts) do
#
#   end
#
#
# end
