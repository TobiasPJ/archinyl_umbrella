defmodule ArchinylWeb.Artists.LibraryTableLive do
  use ArchinylWeb, :live_component

  alias Archinyl.Schema.Library

  @default_assigns [
    add_collection_modal: false
  ]

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{new_collections: collections}, socket) do
    {:ok, assign(socket, collections: collections)}
  end

  def update(assigns, socket) do
    %Library{id: library_id, collections: collections} = Archinyl.get_library(assigns[:user_id])

    socket =
      socket
      |> assign(assigns)
      |> assign(@default_assigns)
      |> assign(collections: collections)
      |> assign(library_id: library_id)

    {:ok, socket}
  end

  @impl true
  def handle_event("open_add_collection_modal", _, socket) do
    {:noreply, assign(socket, add_collection_modal: true)}
  end

  def handle_event("close_add_collection_modal", _, socket) do
    {:noreply, assign(socket, add_collection_modal: false)}
  end

  def handle_event("go_to_collection", %{"value" => collection_id}, socket) do
    {:noreply, redirect(socket, to: "/go_to_collection#{collection_id}")}
  end
end
