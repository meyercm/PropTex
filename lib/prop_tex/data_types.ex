alias PropTex.DataTypes
defmodule PropTex.DataTypes do
  def any(depth \\ 5) do
    options = [
      DataTypes.Integer.any,
      DataTypes.Float.any,
    ]
    options = case depth do
      0 -> options
      _more -> [DataTypes.List.of(DataTypes.any(depth-1),length: DataTypes.Integer.between(0, 20))|options]
    end
    DataTypes.Choose.from(options)
  end
end
