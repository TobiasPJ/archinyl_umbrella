defmodule ArchinylWeb.CollectionLive do
  use ArchinylWeb, :live_view

  alias Archinyl.Schema.Collection

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
          case session["collection_id"] do
            nil ->
              socket =
                socket
                |> assign(@default_assigns)
                |> assign(user_id: user_id)

              {:ok, socket}

            collection_id ->
              collection = Archinyl.get_collection(collection_id)

              socket =
                socket
                |> assign(@default_assigns)
                |> assign(user_id: user_id)
                |> assign(collection: collection)

              {:ok, socket}
          end
      end
    else
      {:ok, assign(socket, @default_assigns)}
    end
  end
end
