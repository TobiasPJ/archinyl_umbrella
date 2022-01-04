defmodule ArchinylWeb.LibraryLive do
  use ArchinylWeb, :live_view

  alias ArchinylWeb.Artists.LibraryTableLive

  @default_assigns [
    search_term: ""
  ]

  @impl true
  def mount(_args, session, socket) do
    socket = assign(socket, @default_assigns)

    if session["current_user"] do
      user_id = session["current_user"]
      Phoenix.PubSub.subscribe(Archinyl.PubSub, "collections")

      {:ok, assign(socket, user_id: user_id)}
    else
      {:ok, socket}
    end
  end

  @impl true
  def handle_info({:new_collections, collections}, socket) do
    send_update(LibraryTableLive, id: "collections_table", new_collections: collections)
    {:noreply, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
