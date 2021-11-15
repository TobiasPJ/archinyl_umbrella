defmodule ArchinylWeb.SessionController do
  use ArchinylWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, session_params) do
    case Archinyl.Session.login(session_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "Logged in")
        |> redirect(to: "/library")

      :error ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("new.html")
    end
  end

  def collection(conn, session_params) do
    conn
    |> put_session(:collection_id, session_params["collection_id"])
    |> redirect(to: "/collection")
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user)
    |> delete_session(:collection_id)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/login")
  end

  def empty_path(conn, _) do
    if ArchinylWeb.Session.logged_in?(conn) do
      conn |> redirect(to: "/library")
    else
      conn |> redirect(to: "/login")
    end
  end
end
