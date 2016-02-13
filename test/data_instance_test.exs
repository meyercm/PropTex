defmodule PropTex.DataInstanceTest do
  use ExUnit.Case
  import PropTex.TestUtils
  import PropTex.Utils.ShortMaps

  @moduletag timeout: 1000


  test "eval literal returns literal" do
    Enum.each([1, 1.0, :hey, "what", ["a", :list], {:a, 'tuple'}, %{maps: :too}, <<3>>, <<3::4>>],
              fn val ->
                assert PropTex.DataInstance.eval_instance(val) == val
              end)
  end

  test "eval float returns float" do
    data_d = PropTex.DataTypes.Float.between(10, 10)
    data_i = PropTex.DataDescription.create_instance(data_d, 1)
    i = PropTex.DataInstance.eval_instance(data_i)
    assert i == 10.0

  end

end
