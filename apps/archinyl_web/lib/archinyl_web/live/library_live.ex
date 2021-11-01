defmodule ArchinylWeb.LibraryLive do
  use ArchinylWeb, :live_view

  @impl true
  def mount(_args, session, socket) do
    if session["current_user"] do
      user_id = session["current_user"]
      {:ok, assign(socket, user_id: user_id)}
    else
      {:ok, socket}
    end
  end
end
