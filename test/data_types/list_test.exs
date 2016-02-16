alias PropTex.{DataInstance, DataDescription, DataTypes}
defmodule PropTex.DataTypes.ListTest do
  use ExUnit.Case
  import PropTex.TestUtils

  test_group "#generate_instance" do
    test "allows :of to contain literals" do
      result = DataTypes.List.of(1, length: 5)
               |> DataDescription.create_instance(1)
               |> DataInstance.eval_instance
      assert result == [1,1,1,1,1]

    end
    test "allows :of to contain non-literals" do
      result = DataTypes.List.of(DataTypes.Integer.between(1,1), length: 5)
               |> DataDescription.create_instance(1)
               |> DataInstance.eval_instance
      assert result == [1,1,1,1,1]
    end
    test "allows :of to contain another non-literal list" do
      result = DataTypes.List.of(DataTypes.List.of(DataTypes.Integer.between(1,1), length: 5), length: 2)
               |> DataDescription.create_instance(1)
               |> DataInstance.eval_instance
      assert result == [[1,1,1,1,1], [1,1,1,1,1]]
    end
    test "allows :length to contain non-literal positive integers" do
      result = DataTypes.List.of(1, length: DataTypes.Integer.between(5,5))
               |> DataDescription.create_instance(1)
               |> DataInstance.eval_instance
      assert result == [1,1,1,1,1]
    end
  end
  test_group "shrinker" do
    test "shrink function doesn't change literals" do
      data_i = DataTypes.List.of(1, length: 5)
               |> DataDescription.create_instance(1)
      assert data_i.value == [1,1,1,1,1]
      shrunk_i = data_i.source.shrink_fun.(data_i)
      assert DataInstance.eval_instance(shrunk_i) == [1,1,1,1,1]
    end
    test "shrink function doesn't change length if literal, shrinks member" do
      data_i = DataTypes.List.of(DataTypes.Integer.between(1, 2), length: 1)
               |> DataDescription.create_instance(1)
      shrunk_i = data_i.source.shrink_fun.(data_i)
      assert DataInstance.eval_instance(shrunk_i) == [1]
    end
  end
end
