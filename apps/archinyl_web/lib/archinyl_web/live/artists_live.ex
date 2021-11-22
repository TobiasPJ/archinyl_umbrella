defmodule ArchinylWeb.ArtistsLive do
  use ArchinylWeb, :live_view

  alias Archinyl.Artist.ArtistTableLive

  @default_assigns [
    artists: [],
    page_number: 1,
    page_size: 15,
    search_term: "",
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
    assign(socket, search_term: search_term || "")
  end

  defp set_page_term(socket, params) do
    page = String.to_integer(params["page"] || "1")
    assign(socket, page_number: page)
  end
end
