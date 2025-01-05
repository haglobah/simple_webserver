defmodule SimpleWebServer do
  def start(port) do
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
    {:ok, request} = :gen_tcp.recv(client, 0)
    path = parse_path(request)
    response = generate_response(path)
    :gen_tcp.send(client, response)
    :gen_tcp.close(client)
  end

  defp parse_path(request) do
    request
    |> to_string()
    |> String.split("\n")
    |> List.first()
    |> String.split(" ")
    |> Enum.at(1)
  end

  defp generate_response(path) do
    cond do
      String.starts_with?(path, "/hello/") ->
        name = String.trim_leading(path, "/hello/")
        body = "Hello, #{name}!"
        content_length = byte_size(body)
        "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{content_length}\r\n\r\n#{body}"

      path == "/hello" ->
        body = "Hello, World!"
        content_length = byte_size(body)
        "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{content_length}\r\n\r\n#{body}"

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
