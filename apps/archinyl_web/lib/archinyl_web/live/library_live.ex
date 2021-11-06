defmodule ArchinylWeb.LibraryLive do
  use ArchinylWeb, :live_view

  alias Archinyl.Schema.Library
  alias Phoenix.HTML.Tag

  @default_assigns [
    collections: [],
    add_collection_modal: false
  ]

  @impl true
  def mount(_args, session, socket) do
    if session["current_user"] do
      user_id = session["current_user"]

      if connected?(socket) do
        %Library{id: library_id} = Archinyl.get_library(user_id)

        collections = Archinyl.get_collections(library_id)

        socket =
          socket
          |> assign(@default_assigns)
          |> assign(user_id: user_id)
          |> assign(collections: collections)
          |> assign(library_id: library_id)

        {:ok, socket}
      else
        {:ok, assign(socket, @default_assigns)}
      end
    else
      {:ok, assign(socket, @default_assigns)}
    end
  end

  @impl true
  def handle_event("open_add_collection_modal", _, socket) do
    {:noreply, assign(socket, add_collection_modal: true)}
  end

  def handle_event("close_add_collection_modal", _, socket) do
    {:noreply, assign(socket, add_collection_modal: false)}
  end

  def handle_event("create_collection", %{"name" => name}, socket) do
    library_id = socket.assigns[:library_id]

    case Archinyl.create_collection(library_id, name) do
      :ok ->
        collections = Archinyl.get_collections(library_id)
        socket = assign(socket, collections: collections)
        {:noreply, socket}

      :error ->
        {:noreply, socket}
    end
  end
end
