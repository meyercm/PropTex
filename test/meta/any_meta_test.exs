alias PropTex.{DataInstance, DataDescription, DataTypes}
defmodule PropTex.Meta.AnyTest do
  use ExUnit.Case
  import PropTex.TestUtils
  import PropTex.Utils.ShortMaps
  import PropTex

  test_group "presets" do
    test "from" do
      list = [:a, :b, :c]
      for_many i <- examples_of(DataTypes.any) do
        IO.inspect(i)
      end
    end
  end

end
