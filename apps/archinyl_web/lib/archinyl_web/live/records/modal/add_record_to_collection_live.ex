defmodule ArchinylWeb.Records.Modal.AddRecordToCollectionLive do
  use ArchinylWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)

    if assigns[:logged_in?] do
      socket = get_collections(socket)

      {:ok, socket}
    else
      {:ok, socket}
    end
  end

  @impl true
  def handle_event("add_record_to_collection", %{"collection_id" => collection_id}, socket) do
    case Archinyl.add_record_to_collection(collection_id, socket.assigns.record_to_add) do
      {:ok, _collection} ->
        Phoenix.PubSub.broadcast!(Archinyl.PubSub, "collection:#{collection_id}", :added_record)
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, error: changeset.errors)}
    end
  end

  defp get_collections(socket) do
    user_id = socket.assigns[:logged_in?]

    case Archinyl.get_library(user_id) do
      nil -> socket
      library -> assign(socket, collections: library.collections)
    end
  end
end
