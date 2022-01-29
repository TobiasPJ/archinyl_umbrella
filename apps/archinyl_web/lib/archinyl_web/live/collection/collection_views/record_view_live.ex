defmodule ArchinylWeb.Collection.CollectionViews.RecordViewLive do
  use ArchinylWeb, :live_component

  @default_assigns [
    show_record_information: false
  ]

  @impl true
  def mount(socket) do
    {:ok, assign(socket, self: self())}
  end

  @impl true
  def update(%{show_record_information: val}, socket) do
    {:ok, assign(socket, record: nil, show_record_information: val)}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(@default_assigns)

    {:ok, socket}
  end

  @impl true
  def handle_event("remove_record_from_collection", %{"value" => record_id}, socket) do
    case Archinyl.remove_record_from_collection(socket.assigns.collection, record_id) do
      {:ok, _collecion} ->
        Phoenix.PubSub.broadcast!(
          Archinyl.PubSub,
          "collection:#{socket.assigns.collection.id}",
          :record_removed
        )

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, error: changeset.errors)}
    end
  end

  def handle_event("view_record_information", %{"value" => record_id}, socket) do
    record = Archinyl.get_record(record_id)
    {:noreply, assign(socket, record: record, show_record_information: true)}
  end
end
