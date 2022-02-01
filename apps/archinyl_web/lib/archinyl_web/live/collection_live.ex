defmodule ArchinylWeb.CollectionLive do
  use ArchinylWeb, :live_view

  alias Archinyl.Schema.Collection
  alias ArchinylWeb.Collection.CollectionTableLive
  alias ArchinylWeb.Collection.CollectionViews.RecordViewLive

  @default_assigns [
    collection: %Collection{}
  ]

  @impl true
  def mount(_args, session, socket) do
    if connected?(socket) do
      case session["current_user"] do
        nil ->
          {:ok, socket}

        user_id ->
          collection_id = session["collection_id"]
          Phoenix.PubSub.subscribe(Archinyl.PubSub, "collection:#{collection_id}")

          socket =
            socket
            |> assign(@default_assigns)
            |> assign(user_id: user_id)
            |> assign(collection_id: collection_id)

          {:ok, socket}
      end
    else
      {:ok, assign(socket, @default_assigns)}
    end
  end

  @impl true
  def handle_info(:added_record, socket) do
    send_update(CollectionTableLive, id: "collection_table")
    {:noreply, socket}
  end

  def handle_info(:record_removed, socket) do
    send_update(CollectionTableLive, id: "collection_table")
    {:noreply, socket}
  end

  def handle_info(:close_record_inforamtion_modal, socket) do
    send_update(RecordViewLive, id: "record_view_live", show_record_information: false)
    {:noreply, socket}
  end
end
