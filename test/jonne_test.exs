defmodule JonneTest do
  use ExUnit.Case
  doctest Jonne

  test "greets the world" do
    assert Jonne.hello() == :world
  end
end
