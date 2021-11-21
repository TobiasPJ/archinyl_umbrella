defmodule Archinyl do
  def get_library(user_id) do
    Archinyl.Repo.get_library(user_id)
  end

  def create_collection(library_id, name) do
    Archinyl.Repo.insert_collection(library_id, name)
  end

  def remove_collection(library_id, collection_id) do
    Archinyl.Repo.remove_collection(library_id, collection_id)
  end

  def get_collection(collection_id) do
    Archinyl.Repo.get_collection(collection_id)
  end

  def insert_artist(name, birthday, sex, picture_url \\ "", description \\ "") do
    Archinyl.Repo.insert_artist(name, birthday, sex, picture_url, description)
  end

  def get_records(search_term, limit, offset) do
    Archinyl.Repo.get_records(search_term, limit, offset)
  end

  def get_record(record_id) do
    Archinyl.Repo.get_record(record_id)
  end

  def create_record(title, artist_id, songs, cover_url \\ nil) do
    {:ok, record} = Archinyl.Repo.create_record(title, artist_id, cover_url)
    songs = Enum.map(songs, &Map.put(&1, :artist_id, String.to_integer(artist_id)))

    Archinyl.Repo.update_record_songs(record, songs)
  end

  def get_collections(library_id) do
    Archinyl.Repo.get_collections(library_id)
  end

  def add_record_to_collection(record_id, collection_id) do
    Archinyl.Repo.insert_record_into_collection(record_id, collection_id)
  end

  def get_artists(search_term, limit, offset) do
    Archinyl.Repo.get_artists(search_term, limit, offset)
  end

  def get_artists do
    Archinyl.Repo.get_artists()
  end
end
