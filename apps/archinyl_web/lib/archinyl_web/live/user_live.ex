defmodule ArchinylWeb.UserLive do
  use ArchinylWeb, :live_view

  @impl true
  def mount(_arg0, session, socket) do
    logged_in = session["current_user"]

    {:ok, assign(socket, logged_in?: logged_in)}
  end
end
