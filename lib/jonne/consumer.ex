defmodule Jonne.Consumer do
  @callback consume(document: %{}) :: any
end
