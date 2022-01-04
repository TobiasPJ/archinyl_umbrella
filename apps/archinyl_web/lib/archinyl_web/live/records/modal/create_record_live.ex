defmodule ArchinylWeb.Records.Modal.CreateRecordLive do
  use ArchinylWeb, :live_component

  alias Archinyl.Schema.Song

  @default_assigns [
    artists: [],
    add_record_songs: [],
    album_title: "",
    image_url: "",
    embed_link: "",
    is_error: false,
    error_type: nil
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
  def handle_event("add_song_to_record", %{"title" => title, "runtime" => runtime}, socket) do
    add_record_songs = socket.assigns[:add_record_songs]
    {:ok, runtime} = Time.from_iso8601("00:" <> runtime)

    add_record_songs = add_record_songs ++ [%Song{title: title, runtime: runtime}]

    {:noreply, assign(socket, add_record_songs: add_record_songs)}
  end

  def handle_event("remove_song_from_record", %{"value" => title}, socket) do
    add_record_songs = socket.assigns[:add_record_songs]
    song = Enum.find(add_record_songs, [], &(&1.title == title))
    add_record_songs = add_record_songs -- [song]

    {:noreply, assign(socket, add_record_songs: add_record_songs)}
  end

  def handle_event("search_record", _params, socket) do
    album_title = socket.assigns[:album_title]

    if album_title do
      case Archinyl.spotify_search_album(socket.assigns[:album_title]) do
        {:ok, album} ->
          {:noreply,
           assign(socket,
             album_title: album[:title],
             add_record_songs: album[:songs],
             image_url: album[:image],
             embed_link: album[:embed_link]
           )}

        {:error, :does_not_exist} ->
          {:noreply, assign(socket, error_type: :record_name, is_error: true)}

        {:error, _reason} ->
          {:noreply, socket}
      end
    end
  end

  def handle_event("set_album_search_value", %{"title" => title}, socket) do
    {:noreply, assign(socket, album_title: title)}
  end

  def handle_event("create_record", params, socket) do
    %{
      "artist_id" => artist_id,
      "cover_url" => cover_url
    } = params

    %{
      album_title: title,
      embed_link: embed_link,
      add_record_songs: songs
    } = socket.assigns

    case Archinyl.create_record(title, artist_id, songs, embed_link, cover_url) do
      {:ok, record} ->
        Phoenix.PubSub.broadcast!(Archinyl.PubSub, "records", {:new_record, record})
        {:noreply, socket}

      {:error, changeset} ->
        error_type = changeset.errors |> hd() |> elem(0)

        {:noreply,
         assign(socket,
           error_type: error_type,
           is_error: true
         )}
    end
  end
end
