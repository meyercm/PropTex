alias PropTex.{DataInstance, DataDescription, DataTypes}
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
    data_d = DataTypes.Float.between(10, 10)
    data_i = DataDescription.create_instance(data_d, 1)
    i = DataInstance.eval_instance(data_i)
    assert i == 10.0

  end

  test "eval can eval nested types" do
    int_instance =
    %DataInstance{shrink_info: [1],
                  source: %DataDescription{data_options: %{bounds: %{lower: 1, upper: 1}, preset: :between},
                                           module: DataTypes.Integer,
                                           shrink_fun: &(&1)},
                  value: 1}
    list_instance =
    %DataInstance{shrink_info: [:something_complicated],
                  source: %DataDescription{data_options: %{length: 1, prototype: :something_complicated, preset: :of},
                                           module: DataTypes.List,
                                           shrink_fun: &(&1)},
                  value: [int_instance]}
    assert DataInstance.eval_instance(list_instance) == [1]
  end

end
