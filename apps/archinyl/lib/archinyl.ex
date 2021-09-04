defmodule Archinyl do
  import Bcrypt.Base
  alias Archinyl.Schema.User
  alias Archinyl.Schema.Library
  alias Archinyl.Schema.Collection
  alias Archinyl.Schema.Artist
  alias Archinyl.Schema.Record
  alias Archinyl.Schema.Song

  @salt "$2b$12$4BJUL0QXzfg2U/7n5j2ZPO"

  def register(%User{
        full_name: full_name,
        username: username,
        email: email,
        password: password
      }) do
    case Archinyl.Repo.get_user(email) do
      nil ->
        password = hash_password(password, @salt)

        {:ok, %User{id: id}} =
          Archinyl.Repo.insert_user(%User{
            full_name: full_name,
            username: username,
            email: email,
            password: password
          })

        Archinyl.Repo.insert_library(%Library{user_id: id})

        {:ok, id}

      _ ->
        {:error, "An account with email #{email} already exists"}
    end
  end

  def login(email, password) do
    case Archinyl.Repo.get_user(email) do
      nil ->
        {:error, "No user with given email"}

      %User{id: id, password: user_password} ->
        password = hash_password(password, @salt)

        case user_password do
          ^password ->
            %Library{id: library_id} = Archinyl.Repo.get_library(id)
            {:ok, library_id}

          _ ->
            {:error, "Wrong password"}
        end
    end
  end

  def create_collection(library, name) do
    case Archinyl.Repo.insert_collection(%Collection{library_id: library, name: name}) do
      {:error, _reason} -> :error
      {:ok, _collection} -> :ok
    end
  end

  def insert_artist(%Artist{name: _name, birthday: _birthday, sex: _sex} = artist) do
    Archinyl.Repo.insert_artist(artist)
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

  def get_records_in_collection(collection_id) do
    Archinyl.Repo.get_records_in_collection(collection_id)
  end

  def add_record_to_collection(record_id, collection_id) do
    Archinyl.Repo.insert_record_into_collection(record_id, collection_id)
  end
end
