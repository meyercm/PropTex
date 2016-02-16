alias PropTex.{DataInstance, DataDescription, DataTypes}
defmodule PropTex.Meta.ListTest do
  use ExUnit.Case
  import PropTex.TestUtils
  import PropTex

  test_group "length" do
    test "creates properly-sized lists" do
      for_many i <- examples_of(DataTypes.Integer.between(0, 100_000), iterations: 100) do
        manually_generated = DataTypes.List.of(1, length: i)
                             |> DataDescription.create_instance(1)
                             |> DataInstance.eval_instance
        assert manually_generated == Stream.repeatedly(fn -> 1 end) |> Enum.take(i)
      end
    end

    test "shrinker makes list smaller, keeps front" do
      for_many i <- examples_of(DataTypes.Integer.between(0, 100_000), iterations: 100) do
        data_i = DataTypes.List.of(DataTypes.Float.any, length: DataTypes.Integer.between(0, i))
                 |> DataDescription.create_instance(1)
        data = DataInstance.eval_instance(data_i)
        shrunk_i = data_i.source.shrink_fun.(data_i)
        shrunk = DataInstance.eval_instance(shrunk_i)
        case data do
          [] -> assert shrunk == data
          _more ->
            assert length(shrunk) < length(data)
            assert Enum.take(data, length(data)) == shrunk
        end
      end
    end
  end

  test_group "creation" do
    test "literal lengths" do
      for_many i <- examples_of(DataTypes.Integer.between(0, 100)) do
        for_many list <- examples_of(DataTypes.List.of(DataTypes.Float.any, length: i)) do
          assert length(list) == i
          assert Enum.all?(list, &is_float/1)
        end
      end
    end
  end

end
