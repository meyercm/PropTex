alias PropTex.{DataTypes}
defmodule PropTex.Meta.GeneralUsageTest do
  use ExUnit.Case
  import PropTex.TestUtils
  import PropTex

  defmodule ExampleStruct do
    defstruct [
      first: 1,
      second: 2,
    ]
  end

  test_group "data types" do
    test "works with user structs" do
      for_many list <- examples_of(DataTypes.List.of(%ExampleStruct{})) do
        case list do
          [] -> :ok
          [h|_t] -> assert match?(%ExampleStruct{first: 1, second: 2}, h)
        end
      end
    end

    test "works with maps" do
      for_many list <- examples_of(DataTypes.List.of(%{a: 1, b: 2})) do
        case list do
          [] -> :ok
          [h|_t] -> assert h == %{a: 1, b: 2}
        end
      end
    end
  end
end
