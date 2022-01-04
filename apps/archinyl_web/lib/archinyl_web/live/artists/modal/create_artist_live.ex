defmodule ArchinylWeb.Artists.Modal.CreateArtistLive do
  use ArchinylWeb, :live_component

  @default_assigns [
    is_error: false,
    error_type: nil,
    name: "",
    picture_url: "",
    description: ""
  ]
  @impl true
  def mount(socket) do
    {:ok, assign(socket, @default_assigns)}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("update_artist_name", %{"name" => name}, socket) do
    {:noreply, assign(socket, name: name)}
  end

  def handle_event("get_artist_information", _params, socket) do
    name = socket.assigns[:name]

    with true <- name != "",
         {:ok, %{name: artist_name, image_url: image_url}} <-
           Archinyl.spotify_search_artist(name),
         {:ok, description} <- Archinyl.get_artist_desc(artist_name) do
      {:noreply,
       assign(socket, name: artist_name, picture_url: image_url, description: description)}
    else
      {:error, _reason} -> {:noreply, socket}
      _ -> {:noreply, socket}
    end
  end

  def handle_event(
        "create_artist",
        %{
          "description" => description,
          "gender" => gender,
          "picture_url" => picture_url,
          "birthday" => birthday
        },
        socket
      ) do
    name = socket.assigns[:name]

    if Archinyl.check_if_artist_exist(name, birthday) do
      {:noreply, assign(socket, is_error: true, error_type: :artist_exists)}
    else
      {:ok, artist} = Archinyl.insert_artist(name, birthday, gender, picture_url, description)

      Phoenix.PubSub.broadcast!(
        Archinyl.PubSub,
        "artists",
        {:new_artist, artist}
      )

      {:noreply, assign(socket, is_error: false, error_type: nil)}
    end
  end
end
