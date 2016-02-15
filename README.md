# PropTex

[![Build Status](https://travis-ci.org/meyercm/PropTex.svg?branch=master)](http://travis-ci.org/meyercm/PropTex)

An experiment in property-based testing.  

**This is not ready to use.**

Feel free to create an issue if you have any thoughts on syntax, or if you have an idea how to structure it better, an idea for a better name, or anything else you think would help.

## Discussion

I'm tired of `:triq`'s miserable Erlang macro syntax;  I wish that it could handle `Map` natively.  `ExCheck` is nice, and I use it in production, but I'm ready for an Elixir-native version.  Until that day comes, I'll probably keep hacking on this.  

### In case you missed it before, this is not ready to use. Seriously. Don't use it.

### Goals:

 - Elixir-native codebase
 - Simple, plain syntax for generators
 - Available for use directly from the console
 - Easy integration with test libraries
 - More powerful shrinking than available from :triq
 - Easy to mix literals and generators

### Current Features

 - Generators: `List`, `Integer`, `Float`
 - Shrinking
 - Iteration set per test
 - Nestable loops
 - Freely mix literals and generators

### Future Features
 - More Generators.  In approximate implementation order:
  1. `Any`
  1. `Choice`
  2. `Tuple`
  3. `Map`
  4. `String`
  5. `Atom`
  6. `Binary`
  7. `Bitstring`
  8. `Lambda` <= Maybe.  I was kinda tired when I wrote that idea down
 - Multiple Shrinking paths; e.g. division and subtraction, to better find the edge of passing.
 - Accumulator: specify a lambda reduce body to collect information from the inside of the `for_many` loop
 - Less insane codebase.  Currently, there is so much indirection to manage the difference between literals and generators, descriptions of generators and instances of their values that it's pretty tough to follow through the codebase.
 - Might be cool to examine typespecs; maybe have a mix-task to generate propery tests for a module based on them.

## Syntax Examples (current code)

Check out `test/meta/*` for other real examples

From the 'meta' section of tests, confirming that positive Floats are actually positive:
```elixir
alias PropTex.DataTypes
test "positive" do
  for_many i <- examples_of(DataTypes.Float.positive) do
    assert i > 0
  end
end
```

Literals work in combination with generators now.  The following code is hypothetical, but is supported with current syntax. It creates examples of the `MyPosition` struct, with fields set by generators.

```elixir
alias PropTex.DataTypes, as: Dt #not sure I like this.
test "my geo helper works" do
  for_many pos <- examples_of(
                    %MyPosition{id: Dt.Integer.between(1,10_000),
                                lat: Dt.Float.between(-90, 90, precision: 1),
                                lng: Dt.Float.between(-180, 180, precision: 1)}) do

    # Just check that it doesn't crash until we can build an oracle
    Geo.to_spherical(pos)
  end
end
```

Lists are a compound data type. Note the first example, with a Generator in the properties of another Generator.  This allows shrinking the size of the list using the shrinking properties of one of a specific generator (integers, in this case):

```elixir
alias PropTex.DataTypes, as: Dt
test "list of ones" do
  for_many list <- examples_of(Dt.List.of(1, length: Dt.Integer.between(0,10)) do
    assert length(list) >= 0 and legnth(list <= 10)
    assert Enum.all?(list, &(&1 == 1))
  end
end

test "list of floats" do
  for_many list <- examples_of(Dt.List.of(Dt.Float.any, length: 100) do
    assert length(list) == 100
    assert Enum.all?(list, &is_float/1)
  end
end
```

## Syntax Ideas for future work
```elixir
Dt.Map.with(keys: Dt.Integer.positive,
            values: Dt.List.of(struct_generator),
            length: Dt.Integer.between(0,100)))
Dt.Choose.from([:a, :b, Dt.Integer.positive])
Dt.Choose.freq([{:a, 1}, {:b, 0.5}, {Dt.Integer.positive, 0.1}])            
```

## License

DWTFYW+Pizza & Beer
