defmodule ArchinylWeb.Records.CreateRecordModalLive do
  use ArchinylWeb, :live_component

  alias Archinyl.Schema.Song

  @default_assigns [
    artists: [],
    add_record_songs: []
  ]

  @impl true
  def mount(socket) do
    artists = Archinyl.get_artists()

    socket =
      socket
      |> assign(@default_assigns)
      |> assign(artists: artists)

    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("add_song_to_record", %{"song_title" => title, "runtime" => runtime}, socket) do
    add_record_songs = socket.assigns[:add_record_songs]
    {:ok, runtime} = Time.from_iso8601("00:" <> runtime)

    add_record_songs = [
      %Song{title: title, runtime: runtime} | add_record_songs
    ]

    {:noreply, assign(socket, add_record_songs: add_record_songs)}
  end

  def handle_event("remove_song_from_record", %{"value" => title}, socket) do
    add_record_songs = socket.assigns[:add_record_songs]
    song = Enum.find(add_record_songs, [], &(&1.title == title))
    add_record_songs = add_record_songs -- [song]

    {:noreply, assign(socket, add_record_songs: add_record_songs)}
  end

  def handle_event("create_record", params, socket) do
    %{
      "artist_id" => artist_id,
      "title" => title,
      "cover_url" => cover_url
    } = params

    songs = socket.assigns[:add_record_songs]

    case Archinyl.create_record(title, artist_id, songs, cover_url) do
      {:ok, record} ->
        Phoenix.PubSub.broadcast!(Archinyl.PubSub, "records", {:new_record, record})
        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, assign(socket, add_record_songs: [], add_record_modal: false)}
    end
  end
end
