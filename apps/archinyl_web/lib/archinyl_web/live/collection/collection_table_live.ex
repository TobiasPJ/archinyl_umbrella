defmodule ArchinylWeb.Collection.CollectionTableLive do
  use ArchinylWeb, :live_component

  @default_assigns [
    record_view: true,
    song_view: false,
    record_view_class: "is-active",
    song_view_class: ""
  ]

  @impl true
  def mount(socket) do
    {:ok, assign(socket, self: self())}
  end

  @impl true

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(@default_assigns)

    socket =
      if assigns.collection_id do
        socket
        |> get_collection()
        |> get_record_count()
        |> get_song_count()
        |> get_most_frequent_artist()
        |> calc_total_playtime()
      else
        socket
      end

    {:ok, socket}
  end

  @impl true
  def handle_event("switch_view", %{"view" => view}, socket) do
    socket =
      case view do
        "song" ->
          assign(socket,
            song_view: true,
            record_view: false,
            record_view_class: "",
            song_view_class: "is-active"
          )

        "record" ->
          assign(socket,
            song_view: false,
            record_view: true,
            record_view_class: "is-active",
            song_view_class: ""
          )
      end

    {:noreply, socket}
  end

  defp get_collection(socket) do
    collection = Archinyl.get_collection(socket.assigns.collection_id)
    assign(socket, collection: collection)
  end

  defp get_record_count(socket),
    do: assign(socket, record_count: length(socket.assigns.collection.records))

  defp get_most_frequent_artist(socket) do
    artists_freq =
      socket.assigns.collection.records |> Enum.map(& &1.artist.name) |> Enum.frequencies()

    case Map.values(artists_freq) do
      [_ | _] = f ->
        max_freq = Enum.max(f)
        {artist, _} = Enum.find(artists_freq, fn {_key, value} -> value == max_freq end)

        assign(socket, most_freq_artist: artist)

      _ ->
        assign(socket, most_freq_artist: nil)
    end
  end

  defp calc_total_playtime(socket) do
    total =
      for record <- socket.assigns.collection.records, song <- record.songs do
        elem(Time.to_seconds_after_midnight(song.runtime), 0)
      end
      |> Enum.sum()
      |> Time.from_seconds_after_midnight()

    assign(socket, total_runtime: total)
  end

  defp get_song_count(socket) do
    total_count =
      for record <- socket.assigns.collection.records, _song <- record.songs do
        ""
      end
      |> length()

    assign(socket, song_count: total_count)
  end
end
