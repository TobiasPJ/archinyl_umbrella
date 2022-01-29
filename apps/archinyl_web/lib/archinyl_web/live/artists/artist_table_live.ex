defmodule ArchinylWeb.Artists.ArtistTableLive do
  use ArchinylWeb, :live_component

  @default_assigns [
    artists: [],
    page_number: 1,
    page_size: 15,
    search: "",
    creating_artist: false
  ]

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(@default_assigns)
      |> get_artists()

    {:ok, socket}
  end

  @impl true
  def update(%{new_description_for: _id}, socket) do
    {:ok, get_artists(socket)}
  end

  def update(%{new_picture_url: _id}, socket) do
    {:ok, get_artists(socket)}
  end

  def update(%{new_artist: _artist}, socket) do
    {:ok, get_artists(socket)}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> get_artists()

    {:ok, socket}
  end

  @impl true
  def handle_event("open_create_artist_modal", _params, socket) do
    {:noreply, assign(socket, creating_artist: true)}
  end

  def handle_event("close_create_artist_modal", _params, socket) do
    {:noreply, assign(socket, creating_artist: false)}
  end

  def handle_event("open_artist_information", %{"artist_id" => artist_id}, socket) do
    set_params(socket, %{artist_information: "opened", artist: artist_id})
  end

  def handle_event("close_artist_information", _params, socket) do
    set_params(socket, %{artist_information: "closed", artist: nil})
  end

  def handle_event("search_artists", %{"search" => search}, socket) do
    set_params(socket, %{search: search})
  end

  defp set_params(socket, params) do
    %{
      artist_information: artist_information,
      artist: artist,
      search: search_term
    } = Map.merge(socket.assigns, params)

    {:noreply,
     push_patch(socket,
       to:
         Routes.artists_path(socket, :artist,
           artist_information: artist_information,
           artist: artist,
           search: search_term
         )
     )}
  end

  defp get_artists(socket) do
    %{
      assigns: %{
        search: search,
        page_size: limit,
        page_number: page_number
      }
    } = socket

    offset = (page_number - 1) * limit

    %{artists: artists, total_count: total_count} = Archinyl.get_artists(search, limit, offset)

    assign(socket,
      artists: artists,
      total_count: total_count,
      number_of_pages: ceil(total_count / limit)
    )
  end
end
