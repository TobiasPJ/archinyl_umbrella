defmodule ArchinylWeb.ArtistsLive do
  use ArchinylWeb, :live_view

  alias ArchinylWeb.Artists.ArtistTableLive

  @default_assigns [
    artists: [],
    page_number: 1,
    page_size: 15,
    search: "",
    artist_information: "closed",
    artist: nil
  ]

  @impl true
  def mount(_arg0, session, socket) do
    logged_in? = session["current_user"]

    socket =
      socket
      |> assign(logged_in?: logged_in?)
      |> assign(@default_assigns)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> set_artist(params)
      |> set_artist_information(params)
      |> set_search_term(params)
      |> set_page_term(params)

    Phoenix.PubSub.subscribe(Archinyl.PubSub, "artists")
    Phoenix.PubSub.subscribe(Archinyl.PubSub, "artist")

    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_description_for, id}, socket) do
    send_update(ArtistTableLive, id: "artists_table", new_description_for: id)
    {:noreply, socket}
  end

  def handle_info({:new_picture_url, id}, socket) do
    send_update(ArtistTableLive, id: "artists_table", new_picture_url: id)
    {:noreply, socket}
  end

  def handle_info({:new_artist, artist}, socket) do
    send_update(ArtistTableLive, id: "artists_table", new_artist: artist)
    {:noreply, socket}
  end

  defp set_artist(socket, params) do
    artist = params["artist"]
    assign(socket, artist: artist)
  end

  defp set_artist_information(socket, params) do
    case params["artist_information"] do
      "opened" -> assign(socket, artist_information: true)
      "closed" -> assign(socket, artist_information: false)
      _ -> assign(socket, artist_information: false)
    end
  end

  defp set_search_term(socket, params) do
    search_term = params["search"]
    assign(socket, search: search_term || "")
  end

  defp set_page_term(socket, params) do
    page = String.to_integer(params["page"] || "1")
    assign(socket, page_number: page)
  end
end
