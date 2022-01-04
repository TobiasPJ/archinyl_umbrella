defmodule ArchinylWeb.Library.Modal.CreateCollectionLive do
  use ArchinylWeb, :live_component

  alias Archinyl.Schema.Library

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)

    {:ok, socket}
  end

  @impl true

  def handle_event("create_collection", %{"name" => name}, socket) do
    library_id = socket.assigns[:library_id]

    case Archinyl.create_collection(library_id, name) do
      {:ok, %Library{collections: collections}} ->
        Phoenix.PubSub.broadcast!(
          Archinyl.PubSub,
          "collections",
          {:new_collections, collections}
        )

        {:noreply, socket}

      {:error, _} ->
        {:noreply, socket}
    end
  end
end
