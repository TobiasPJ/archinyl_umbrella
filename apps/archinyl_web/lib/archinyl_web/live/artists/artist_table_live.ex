defmodule ArchinylWeb.Artists.ArtistTableLive do
  use ArchinylWeb, :live_component

  @default_assigns [
    artists: [],
    page_number: 1,
    page_size: 15,
    search_term: "",
    creating_artist: false
  ]

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(@default_assigns)
      |> get_artists()
      |> calculate_age()

    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> get_artists()
      |> calculate_age()

    {:ok, socket}
  end

  @impl true
  def handle_event("open_create_artist_modal", _params, socket) do
    {:noreply, assign(socket, creating_artist: true)}
  end

  def handle_event("open_artist_information", %{"artist_id" => artist_id}, socket) do
    set_params(socket, %{artist_information: "opened", artist: artist_id})
  end

  def handle_event("close_artist_information", _params, socket) do
    set_params(socket, %{artist_information: "closed", artist: nil})
  end

  defp set_params(socket, params) do
    %{
      artist_information: artist_information,
      artist: artist
    } = params

    {:noreply,
     push_patch(socket,
       to:
         Routes.artists_path(socket, :artist,
           artist_information: artist_information,
           artist: artist
         )
     )}
  end

  defp get_artists(socket) do
    %{
      assigns: %{
        search_term: search_term,
        page_size: limit,
        page_number: page_number
      }
    } = socket

    offset = (page_number - 1) * limit

    %{artists: artists, total_count: total_count} =
      Archinyl.get_artists(search_term, limit, offset)

    assign(socket,
      artists: artists,
      total_count: total_count,
      number_of_pages: ceil(total_count / limit)
    )
  end

  defp calculate_age(socket) do
    artists = socket.assigns[:artists]

    artists =
      Enum.map(artists, fn artist ->
        age =
          DateTime.utc_now()
          |> DateTime.to_date()
          |> Date.diff(artist.birthday)
          |> Kernel.div(365)
          |> floor()

        Map.put(artist, :age, age)
      end)

    assign(socket, artists: artists)
  end
end
