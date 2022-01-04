defmodule ArchinylWeb.Artists.Modal.ArtistInformationLive do
  use ArchinylWeb, :live_component

  @default_assigns [
    edit_description: false,
    edit_picture_url: false
  ]

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    artist = Archinyl.get_artist(assigns.artist)

    age =
      DateTime.utc_now()
      |> DateTime.to_date()
      |> Date.diff(artist.birthday)
      |> Kernel.div(365)
      |> floor()

    artist = Map.put(artist, :age, age)

    socket =
      socket
      |> assign(@default_assigns)
      |> assign(assigns)
      |> assign(artist: artist)

    {:ok, socket}
  end

  @impl true
  def handle_event("start_edit_descripton", _params, socket) do
    {:noreply, assign(socket, edit_description: true)}
  end

  def handle_event("start_edit_picture_url", _params, socket) do
    {:noreply, assign(socket, edit_picture_url: true)}
  end

  def handle_event("edit_artist", %{"picture_url" => picture_url}, socket) do
    id = socket.assigns.artist.id
    Archinyl.update_artist(id, %{picture_url: picture_url})

    artist = %{socket.assigns.artist | picture_url: picture_url}

    Phoenix.PubSub.broadcast!(
      Archinyl.PubSub,
      "artist",
      {:new_picture_url, id}
    )

    {:noreply, assign(socket, edit_picture_url: false, artist: artist)}
  end

  def handle_event("edit_artist", %{"description" => new_description}, socket) do
    id = socket.assigns.artist.id
    Archinyl.update_artist(id, %{description: new_description})

    artist = %{socket.assigns.artist | description: new_description}

    Phoenix.PubSub.broadcast!(
      Archinyl.PubSub,
      "artist",
      {:new_description_for, id}
    )

    {:noreply, assign(socket, edit_description: false, artist: artist)}
  end
end
