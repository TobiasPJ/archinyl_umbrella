defmodule Archinyl do
  alias Archinyl.Schema.Artist
  alias Archinyl.Schema.Record
  alias Archinyl.Schema.Song

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

  def insert_artist(%Artist{name: _name, birthday: _birthday, sex: _sex} = artist) do
    Archinyl.Repo.insert_artist(artist)
  end

  def get_records do
    Archinyl.Repo.get_records()
  end

  def create_record(title, artist_name, songs) do
    with %Artist{id: artist_id} <- Archinyl.Repo.get_artist(artist_name),
         {:ok, %Record{id: record_id}} <-
           Archinyl.Repo.create_record(%Record{title: title, artist_id: artist_id}),
         _songs <-
           Enum.each(songs, fn %Song{title: title, runtime: runtime} ->
             Archinyl.Repo.insert_song(%Song{
               title: title,
               runtime: runtime,
               artist_id: artist_id,
               record_id: record_id
             })
           end) do
      {:ok, record_id}
    else
      {:error, _reason} -> :error
    end
  end

  def get_collections(library_id) do
    Archinyl.Repo.get_collections(library_id)
  end

  def add_record_to_collection(record_id, collection_id) do
    Archinyl.Repo.insert_record_into_collection(record_id, collection_id)
  end

  def get_artists do
    Archinyl.Repo.get_artists()
  end
end
