alias PropTex.{DataTypes}
defmodule PropTex.Meta.FloatTest do
  use ExUnit.Case
  import PropTex.TestUtils
  import PropTex

  test_group "presets" do
    test "positive" do
      for_many i <- examples_of(DataTypes.Float.positive) do
        assert i > 0
      end
    end
    test "negative" do
      for_many i <- examples_of(DataTypes.Float.negative) do
        assert i < 0
      end
    end
    test "any" do
      for_many i <- examples_of(DataTypes.Float.any) do
        assert is_float(i)
      end
    end

    test "between" do
      for_many {i, j} <- examples_of({DataTypes.Float.any,
                                      DataTypes.Float.positive}) do
        for_many k <- examples_of(DataTypes.Float.between(i, i+j), iterations: 10) do
          assert i <= k
          assert k <= i+j
        end
      end
    end
  end

end
