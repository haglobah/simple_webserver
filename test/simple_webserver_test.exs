defmodule SimpleWebserverTest do
  use ExUnit.Case
  doctest SimpleWebserver

  test "greets the world" do
    assert SimpleWebserver.hello() == :world
  end
end
