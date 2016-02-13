defmodule PropTex.DataDescriptionTest do
  use ExUnit.Case
  import PropTex.TestUtils
  import PropTex.Utils.ShortMaps

  test "create instance of literal returns literal" do
    Enum.each([1, 1.0, :hey, "what", ["a", :list], {:a, 'tuple'}, %{maps: :too}, <<3>>, <<3::4>>],
              fn val ->
                assert PropTex.DataDescription.create_instance(val, 1) == val
              end)
  end

  test "create instance of float returns float" do
    data = PropTex.DataTypes.Float.between(10, 10)
    instance = PropTex.DataDescription.create_instance(data, 1)
    assert instance.__struct__ == PropTex.DataInstance
    assert instance.value == 10.0
    assert instance.source.module == PropTex.DataTypes.Float
  end

end
