alias PropTex.{DataInstance, DataDescription, DataTypes}
defmodule PropTex.Meta.IntegerTest do
  use ExUnit.Case
  import PropTex.TestUtils
  import PropTex.Utils.ShortMaps
  import PropTex

  test_group "presets" do
    test "positive" do
      for_many i <- examples_of(DataTypes.Integer.positive) do
        assert i > 0
      end
    end
    test "negative" do
      for_many i <- examples_of(DataTypes.Integer.negative) do
        assert i < 0
      end
    end
    test "any" do
      for_many i <- examples_of(DataTypes.Integer.any) do
        assert is_integer(i)
      end
    end

    test "between" do
      for_many {i, j} <- examples_of({DataTypes.Integer.any,
                                      DataTypes.Integer.positive}) do
        for_many k <- examples_of(DataTypes.Integer.between(i, i+j), iterations: 10) do
          assert i <= k
          assert k <= i+j
        end
      end
    end
  end

end
