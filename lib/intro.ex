defmodule Intro do
  @moduledoc """
  A very simple introduction to Elixir.

  iex>
      2
      2 * 8

      "Hallo"
      "Hallo" <> " zu " <> "den TDF!"

      String.split("Hallo zu den TDF!")
      "Hallo zu den TDF!" |> String.split()

      "Hallo" == "Hallo"
      "Hallo" == "Hallö"

      the_message = "Hallo, ich bin Beat"
      other_message = "Hallö, ich bin Beat"

      String.starts_with?(the_message, "Hallo,")

      case String.starts_with?(the_message, "Hallo") do
        true -> "Stimmt!"
        false -> "Stimmt nicht. :("
      end

      Intro.starts_with_hello(the_message)
      Intro.starts_with_hello(die_andere_nachricht)
  """

  def starts_with_hello(nachricht) do
    case String.starts_with?(nachricht, "Hallo") do
        true -> "Stimmt!"
        false -> "Stimmt nicht. :("
    end
  end

  @doc """
  iex>
  request = "GET / localhost:8080"

  Intro.response_v1(request)
  """
  def response_v1(_request) do
    "Hallo, Web!"
  end

  def response_v2a(_request) do
    "HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 30

<p style=\"color: red;\">Hallo zu den TDF!</p>"
  end

  def response_v2b(_request) do
    inhalt = "<p style=\"color: red;\">Hallo zu den TDF!</p>"
    laenge = byte_size(inhalt)
    "HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: #{laenge}

#{inhalt}"
  end

  @doc """
  So, dass es der Browser verstehen kann.

  iex>
  request = "GET / localhost:8080"

  Intro.response_v2(request)
  """
  def response_v2(_request) do
    body = "Hallo zu den TDF!"
    content_length = byte_size(body)

    "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{content_length}\r\n\r\n#{body}"
  end

  @doc """
  So, dass es der Browser es als HTML verstehen kann.

  iex>
  request = "GET / localhost:8080"

  Intro.response_v3(request)
  """
  def response_v3(_request) do
    body = "<h1>Hallo zu den TDF!</h1>"
    content_length = byte_size(body)

    "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: #{content_length}\r\n\r\n#{body}"
  end

  @doc """

  iex>
  request = "GET / localhost:8080"

  request
  |> String.split()
  |> Enum.at(1)

  Intro.response_v4(request)
  """
  def response_v4(request) do
    path = request
      |> String.split()
      |> Enum.at(1)

    case path do
      "/" ->
        body = "<h1>Hallo zu den TDF!</h1>"
        content_length = byte_size(body)

        "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: #{content_length}\r\n\r\n#{body}"
      "/du" ->
        body = "<h1>Hallo, du!</h1>"
        content_length = byte_size(body)

        "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: #{content_length}\r\n\r\n#{body}"
      "/ich" ->
        body = "<h1>Hallo an mich!</h1>"
        content_length = byte_size(body)

        "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: #{content_length}\r\n\r\n#{body}"
    end
  end

  def build_response(body) do
    content_length = byte_size(body)

    "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: #{content_length}\r\n\r\n#{body}"
  end

  def response_v5(request) do
    path = request
      |> String.split()
      |> Enum.at(1)

    case path do
      "/" -> build_response("<h1>Hallo zu den TDF!</h1>")
      "/du" -> build_response("<h1>Hallo, du!</h1>")
      "/ich" -> build_response("<h1>Hallo an mich!</h1>")
    end
  end

  def response_v6(request) do
    path = request
      |> String.split()
      |> Enum.at(1)

    cond do
      path == "/" -> build_response("<h1>Hallo zu den TDF!</h1>")
      path == "/du" -> build_response("<h1>Hallo, du!</h1>")
      path == "/ich" -> build_response("<h1>Hallo an mich!</h1>")
      true ->
        name = String.trim_leading(path, "/")
        build_response("<h1>Hallo, #{name}</h1>")
    end
  end


  def start(port \\ 8080) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts("Web Server runs at localhost:#{port}...")
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

        response = response_v6(request)

        :gen_tcp.send(client, response)
        :gen_tcp.close(client)

      {:error, _msg} ->
        IO.puts("Something went wrong!")
    end
  end
end

