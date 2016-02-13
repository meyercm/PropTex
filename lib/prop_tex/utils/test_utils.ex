defmodule PropTex.TestUtils do
  defmacro test_group(_message \\"", block) do
    quote do
      unquote(block)
    end
  end

  defmacro xtest(message) do
    quote do
      @tag :skip
      test unquote(message), do: :noop
    end
  end
end
