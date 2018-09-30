defmodule MemoryWeb.PageController do
  use MemoryWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def game(conn, %{"game" => game}) do
    render conn, "game.html", game: game
  end
end
