alias PropTex.{DataInstance, DataDescription, DataTypes}
defmodule PropTex.Meta.ChooseTest do
  use ExUnit.Case
  import PropTex.TestUtils
  import PropTex.Utils.ShortMaps
  import PropTex

  test_group "presets" do
    test "from" do
      list = [:a, :b, :c]
      for_many i <- examples_of(DataTypes.Choose.from(list)) do
        assert Enum.member?(list, i)
      end
    end
    test "from_weighted" do
      list_1 = [a: 1.0e-9, b: 1.0e9]
      list_2 = [a: 1.0e9, b: 1.0e-9]
      for_many {i, j} <- examples_of({DataTypes.Choose.from_weighted(list_1),
                                      DataTypes.Choose.from_weighted(list_2)}) do
        assert i == :b
        assert j == :a
      end
    end
  end

  test_group "nesting" do
    test "simple nesting" do
      for_many item <- examples_of(DataTypes.Choose.from([DataTypes.Integer.between(0,0)])) do
        assert item == 0
      end
      for_many item <- examples_of(DataTypes.Choose.from_weighted([{DataTypes.Integer.between(0,0), 1}])) do
        assert item == 0
      end
    end
    test "double nesting" do
      for_many item <- examples_of(DataTypes.Choose.from([DataTypes.Choose.from([DataTypes.Integer.between(0,0)])])) do
        assert item == 0
      end
      for_many item <- examples_of(DataTypes.Choose.from_weighted([DataTypes.Choose.from_weighted([{DataTypes.Integer.between(0,0), 1}, 1}])])) do
        assert item == 0
      end
    end
  end

  #TODO: add another test once we've got Tuple in place.
end
