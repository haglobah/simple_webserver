defmodule SimpleWebserverTest do
  use ExUnit.Case
  doctest SimpleWebserver

  test "greets the world" do
    assert SimpleWebserver.generate_response("") ==
             "HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nContent-Length: 9\r\n\r\nNot Found"
  end
end
