defmodule PropTex.TestUtils do
  defmacro test_group(_message \\"", block) do
    quote do
      unquote(block)
    end
  end
end
