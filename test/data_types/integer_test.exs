defmodule PropTex.DataTypes.IntegerTest do
  use ExUnit.Case
  import PropTex.TestUtils

  test_group "end-to-end tests" do
    test "between preset" do
      data = PropTex.DataTypes.Integer.between(10, 10)
      instance = PropTex.DataDescription.create_instance(data, 1)
      assert instance.__struct__ == PropTex.DataInstance
      assert instance.value == 10
      assert instance.source.module == PropTex.DataTypes.Integer
    end
  end

end
