defmodule ArchinylWeb.Artists.Modal.CreateArtistLive do
  use ArchinylWeb, :live_component

  @default_assigns []

  def mount(socket) do
    IO.inspect(socket, label: "!!!!!!")
    {:ok, assign(socket, @default_assigns)}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def handle_event("create_artist", _params, socket) do
    {:noreply, socket}
  end
end
