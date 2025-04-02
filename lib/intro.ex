defmodule Intro do
  @moduledoc """
  A very simple introduction to Elixir.

  iex>
      2
      2 * 8

      "Hallo"
      "Hallo" <> " zum " <> "Girls' Day!"

      String.split("Hallo zum Girls Day!")
      "Hallo zum Girls' Day" |> String.split()

      "Hallo" == "Hallo"
      "Hallo" == "Hallö"

      die_nachricht = "Hallo, ich bin Beat"

      String.starts_with?(die_nachricht, "Hallo,")

      case String.starts_with?(die_nachricht, "Hallo") do
        true -> "Stimmt!"
        false -> "Stimmt nicht. :("
      end

      Intro.startet_mit_hallo(die_nachricht)
  """

  def startet_mit_hallo(nachricht) do
    case String.starts_with?(nachricht, "Hallo") do
        true -> "Stimmt!"
        false -> "Stimmt nicht. :("
    end
  end

  @doc """
  iex>
  anfrage = "GET / localhost:8080"

  Intro.antwort_v1(anfrage)
  """
  def antwort_v1(_anfrage) do
    "Hallo zum Girls' Day!"
  end

  @doc """
  So, dass es der Browser verstehen kann.

  iex>
  anfrage = "GET / localhost:8080"

  Intro.antwort_v2(anfrage)
  """
  def antwort_v2(_anfrage) do
    body = "Hallo zum Girls' Day!"
    content_length = byte_size(body)

    "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{content_length}\r\n\r\n#{body}"
  end

  @doc """
  So, dass es der Browser es als HTML verstehen kann.

  iex>
  anfrage = "GET / localhost:8080"

  Intro.antwort_v3(anfrage)
  """
  def antwort_v3(_anfrage) do
    body = "<h1>Hallo zum Girls' Day!</h1>"
    content_length = byte_size(body)

    "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: #{content_length}\r\n\r\n#{body}"
  end

  @doc """
  So, dass es der Browser es als HTML verstehen kann.

  iex>
  anfrage = "GET / localhost:8080"

  anfrage
  |> String.split()
  |> Enum.at(1)

  Intro.antwort_v4(anfrage)
  """
  def antwort_v4(anfrage) do
    path = anfrage
      |> String.split()
      |> Enum.at(1)

    case path do
      "/" ->
        body = "<h1>Hallo zum Girls' Day!</h1>"
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

  def baue_antwort(body) do
    content_length = byte_size(body)

    "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: #{content_length}\r\n\r\n#{body}"
  end

  def antwort_v5(anfrage) do
    path = anfrage
      |> String.split()
      |> Enum.at(1)

    case path do
      "/" -> baue_antwort("<h1>Hallo zum Girls' Day!</h1>")
      "/du" -> baue_antwort("<h1>Hallo, du!</h1>")
      "/ich" -> baue_antwort("<h1>Hallo an mich!</h1>")
    end
  end

  def antwort_v6(anfrage) do
    path = anfrage
      |> String.split()
      |> Enum.at(1)

    cond do
      path == "/" -> baue_antwort("<h1>Hallo zum Girls' Day!</h1>")
      path == "/du" -> baue_antwort("<h1>Hallo, du!</h1>")
      path == "/ich" -> baue_antwort("<h1>Hallo an mich!</h1>")
      true ->
        name = String.trim_leading(path, "/")
        baue_antwort("<h1>Hallo, #{name}</h1>")
    end
  end


  def start(port \\ 8080) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts("Webserver läuft auf localhost:#{port}...")
    accept(socket)
  end

  defp accept(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    spawn(fn -> handle_client(client) end)
    accept(socket)
   end

  defp handle_client(client) do
    case :gen_tcp.recv(client, 0) do
      {:ok, anfrage} ->

        die_antwort = antwort_v1(anfrage)

        :gen_tcp.send(client, die_antwort)
        :gen_tcp.close(client)

      {:error, _msg} ->
        IO.puts("Oh, da hat etwas nicht geklappt!")
    end
  end
end
