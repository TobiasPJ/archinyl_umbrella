defmodule ArchinylWeb.RecordsLive do
  use ArchinylWeb, :live_view

  alias Phoenix.HTML.Tag
  alias Archinyl.Schema.Song

  @default_assigns [
    records: [],
    add_record_modal: false,
    artists: [],
    add_record_songs: []
  ]

  @impl true
  def mount(_arg0, session, socket) do
    logged_in? = session["current_user"]

    socket =
      socket
      |> assign(logged_in?: logged_in?)
      |> assign(@default_assigns)

    if connected?(socket) do
      records = Archinyl.get_records()

      {:ok, assign(socket, records: records)}
    else
      {:ok, socket}
    end
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("open_add_record_modal", _params, socket) do
    artists = Archinyl.get_artists()
    {:noreply, assign(socket, add_record_modal: true, artists: artists)}
  end

  def handle_event("close_add_record_modal", _params, socket) do
    {:noreply, assign(socket, add_record_modal: false)}
  end

  def handle_event("add_song_to_record", %{"song_title" => title, "runtime" => runtime}, socket) do
    add_record_songs = socket.assigns[:add_record_songs]
    add_record_songs = [%Song{title: title, runtime: runtime} | add_record_songs]

    {:noreply, assign(socket, add_record_songs: add_record_songs)}
  end

  def handle_event("remove_song_from_record", %{"value" => title}, socket) do
    add_record_songs = socket.assigns[:add_record_songs]
    song = Enum.find(add_record_songs, [], &(&1.title == title))
    add_record_songs = add_record_songs -- [song]

    {:noreply, assign(socket, add_record_songs: add_record_songs)}
  end

  def handle_event("create_record", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end
end
