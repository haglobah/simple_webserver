defmodule SimpleWebserver do
  @moduledoc """
  A simple web server leveraging :gen_tcp that tries to hide as little as possible.

  Run via `iex -S mix`, and then `SimpleWebServer.start(<port>)`
  """
  def start(port \\ 8080) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts("Listening on port #{port}...")
    accept(socket)
  end

  defp accept(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    spawn(fn -> handle_client(client) end)
    accept(socket)
  end

  defp handle_client(client) do
    case :gen_tcp.recv(client, 0) do
      {:ok, request} ->
        path = parse_path(request)
        response = generate_response(path)
        :gen_tcp.send(client, response)
        :gen_tcp.close(client)

      {:error, _msg} ->
        IO.puts("Oh no!")
    end
  end

  defp parse_path(request) do
    request
    |> to_string()
    |> String.split("\n")
    |> List.first()
    |> String.split(" ")
    |> Enum.at(1)
  end

  def generate_response(path) do
    cond do
      String.starts_with?(path, "/hello/") ->
        name = String.trim_leading(path, "/hello/")
        body = "Hello, #{name}!"
        content_length = byte_size(body)

        "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{content_length}\r\n\r\n#{body}"

      path == "/hello" ->
        body = "<h1>Hello, World!</h1>"
        content_length = byte_size(body)

        "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: #{content_length}\r\n\r\n#{body}"

      path == "/goodbye" ->
        body = "Goodbye!!!"
        content_length = byte_size(body)

        "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{content_length}\r\n\r\n#{body}"

      true ->
        body = "Not Found"
        content_length = byte_size(body)

        "HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nContent-Length: #{content_length}\r\n\r\n#{body}"
    end
  end
end
