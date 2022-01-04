defmodule Archinyl do
  alias Archinyl.{
    Repo,
    Spotify,
    TimeConvert,
    LastFM
  }

  def get_library(user_id) do
    Repo.get_library(user_id)
  end

  def create_collection(library_id, name) do
    Repo.insert_collection(library_id, name)
  end

  def remove_collection(library_id, collection_id) do
    Repo.remove_collection(library_id, collection_id)
  end

  def get_collection(collection_id) do
    Repo.get_collection(collection_id)
  end

  def insert_artist(name, birthday, sex, picture_url \\ "", description \\ "") do
    Repo.insert_artist(name, birthday, sex, picture_url, description)
  end

  def get_records(search_term, limit, offset) do
    Repo.get_records(search_term, limit, offset)
  end

  def get_record(record_id) do
    Repo.get_record(record_id)
  end

  def create_record(title, artist_id, songs, embed_link \\ nil, cover_url \\ nil) do
    with {:ok, record} <- Repo.create_record(title, artist_id, embed_link, cover_url),
         songs = Enum.map(songs, &Map.put(&1, :artist_id, String.to_integer(artist_id))) do
      Repo.update_record_songs(record, songs)
    else
      {:error, changeset} -> {:error, changeset}
    end
  end

  def get_collections(library_id) do
    Repo.get_collections(library_id)
  end

  def add_record_to_collection(collection_id, record) do
    Repo.insert_record_into_collection(collection_id, record)
  end

  def remove_record_from_collection(collection, record_id) do
    Repo.remove_record_from_collection(collection, record_id)
  end

  def get_artists(search_term, limit, offset) do
    Repo.get_artists(search_term, limit, offset)
  end

  def get_artists do
    Repo.get_artists()
  end

  def get_artist(id) do
    Repo.get_artist(id)
  end

  def check_if_artist_exist(name, birthday) do
    Repo.check_if_artist_exist(name, birthday)
  end

  def update_artist(artist_id, new_data) do
    Repo.update_artist(artist_id, new_data)
  end

  def spotify_search_artist(query) do
    with {:ok, %{"artists" => %{"items" => items}}} <- Spotify.Client.search(query, "artist"),
         %{"images" => images, "name" => name} = Enum.at(items, 0) do
      max_size = images |> Enum.map(& &1["height"]) |> Enum.max()
      image = Enum.find(images, &(&1["height"] == max_size))
      {:ok, %{image_url: image["url"], name: name}}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  def spotify_search_album(query) do
    with {:ok, %{"albums" => %{"items" => items}}} <- Spotify.Client.search(query, "album"),
         [_ | _] <- items,
         %{
           "artists" => _artists,
           "id" => id,
           "name" => name,
           "images" => images
         } = Enum.at(items, 0),
         {:ok, %{"tracks" => %{"items" => tracks}}} <- Spotify.Client.get_album(id) do
      songs =
        Enum.map(
          tracks,
          &%{
            title: &1["name"],
            runtime: TimeConvert.to_str(&1["duration_ms"])
          }
        )

      max_size = images |> Enum.map(& &1["height"]) |> Enum.max()
      image = Enum.find(images, &(&1["height"] == max_size))

      {:ok,
       %{
         image: image["url"],
         embed_link: "https://open.spotify.com/embed/album/" <> id,
         title: name,
         songs: songs
       }}
    else
      [] ->
        IO.inspect("in empty list")
        {:error, :does_not_exist}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def get_artist_desc(artist) do
    with {:ok, %{"artist" => %{"bio" => %{"content" => content}}}} <-
           LastFM.Client.get_artist_desc(artist) do
      {:ok, content}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
