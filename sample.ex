# another early brainstorming session result

defmodule SampleTest do


  test "All positive integers are greater than 0" do
    for_many i <- examples_of(Integer.positive) do
      assert(i > 0) # need to be able to shink before we crash
    end
  end


  test "my method handles my struct appropriately" do
    a = %MyStruct{a: Float.in(1..10), b: :hey}
    for_many struct <- examples_of(mystruct, max_time: 20,
                                             annotator: fn(item, acc) -> acc + item.a  end ) do
      assert(MyStruct.my_method(value) == value.a)
    end
  end

  a = LateFloat.between(-180, 180, precision: 8)

  %{entry_to_delete: Integer.between(0, 100, id: :entry), list: List.of(choose([Integer.any, length: Integer.between(0, 200), NamedItem(id: :entry))

  test "ecef can be mapped to surface" do
    g_coord = LateFloat.in(1000..4_000_000)
    for_many pt <- examples_of(%{x: g_coord, y: g_coord, z: g_coord}) do
      res = Geo.ecef_to_latlngalt(pt)
      assert res.lat <= 90
      assert res.lat >= -90
      assert res.lng <= 180
      assert res.lng >= -180
    end
  end
end


#
# for_many element <- choose_one([:a, :b, :c])
#
# List.of(Integer.positive, length: Integer.between(0, 100))
# Map.where(keys: Atom.from([a-zA-Z]), values: %MyStruct{name: String.ascii(1, 12)})
# Map.where(keys: Integer.between(0, 1.0e6), values: %{id: Map.key, ) # <- can we make something like this work?

# What if the functions are composable:
# String.ascii.lower_case.length(0, 12)

# Each call could return the module and a set of options-
# Integer.between(0, 200) === Integer.above(0).below(200)

# Map.keys(Integer.positive).values(%{id: Map.key, name: String.ascii, nets: List.of(Integer.positive).length(Integer.positive)})
# Tuple.of(Any)

# That won't work because this isn't OOP.  DURF

# How about pipelining:

# LateInteger
# |> Opts.above(0)
# |> Opts.below(20000000000)

# or maybe
# |> option(above: 0)
# |> option(between: 1..1.0e9)
# |> option()

# vs.
# LateInteger.new(above: 0, below: 2000000000)

# Types:
# Atom
# Integer
# Float
# String
## combo types:
# List
# Map
# Tuple
# Binary
# Bitstring
## magic:
# Any


#sample implementation of pipelined options
defmodule Opts do
  def above(mod, val), do: {mod, apply(mod, :above, [%{}, val])}
  def above({mod, opts}), do: {mod, apply(mod, :above, [opts, val])}
end
def LateInteger do
  def above(opts, val), do: Map.put(opts, :lower, val + 1)
end
