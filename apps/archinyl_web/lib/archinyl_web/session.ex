defmodule ArchinylWeb.Session do
  def logged_in?(conn), do: !!current_user(conn)

  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: Archinyl.Repo.get(Archinyl.Schema.User, id)
  end
end
