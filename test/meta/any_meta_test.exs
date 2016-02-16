alias PropTex.{DataTypes}
defmodule PropTex.Meta.AnyTest do
  use ExUnit.Case
  import PropTex.TestUtils
  import PropTex

  test_group "presets" do
    test "from" do
      for_many _i <- examples_of(DataTypes.any) do
      end
    end
  end

end
