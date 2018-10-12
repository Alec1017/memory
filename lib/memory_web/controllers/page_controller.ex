defmodule MemoryWeb.PageController do
  use MemoryWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def join(conn, %{"join" => %{"user" => user, "game" => game}}) do
    conn
    |> put_session(:user, user)
    |> redirect(to: "/game/#{game}")
  end

  def game(conn, %{"game" => game}) do
    user = get_session(conn, :user)
    if user do
      render conn, "game.html", game: game, user: user
    else
      conn
      |> put_flash(:error, "Must pick a name")
      |> redirect(to: "/")
    end
  end
end
