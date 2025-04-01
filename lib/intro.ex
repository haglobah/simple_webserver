defmodule Intro do
  @moduledoc """
  A very simple introduction to Elixir.

  iex>
      2
      2 * 8

      "Hallo"
      "Hallo" <> " zum " <> "Girls' Day!"

      String.split("Hallo zum Girls Day!")

      "Hallo" == "Hallo"
      "Hallo" == "Hallö"
      Intro.malzwei(5)
  """

  def malzwei(zahl) do
    zahl * 2
  end
end
