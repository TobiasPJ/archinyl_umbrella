defmodule Archinyl.Repo do
  use Ecto.Repo,
    otp_app: :archinyl,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query, only: [where: 3]

  alias Archinyl.Schema.User
  alias Archinyl.Schema.Library
  alias Archinyl.Schema.Collection
  alias Archinyl.Schema.Record
  alias Archinyl.Schema.Artist
  alias Archinyl.Schema.Song
  alias Archinyl.Schema.RecordsInCollection

  def insert_user(user) do
    %User{
      full_name: full_name,
      username: username,
      email: email,
      password: password
    } = user

    user = %User{}
    params = %{full_name: full_name, username: username, email: email, password: password}

    user
    |> User.changeset(params)
    |> insert()
  end

  def insert_library(%Library{user_id: user}) do
    library = %Library{}
    params = %{user_id: user}

    library
    |> Library.changeset(params)
    |> insert()
  end

  def insert_collection(library_id, collection_name) do
    Library
    |> get_by(id: library_id)
    |> preload(:collections)
    |> Library.changeset_insert_collection(collection_name)
    |> update()
  end

  def remove_collection(library_id, collection_id) do
    Library
    |> get_by(id: library_id)
    |> preload(:collections)
    |> Library.changeset_remove_collection(collection_id)
    |> update()
  end

  def create_record(%Record{title: title, artist_id: artist_id}) do
    record = %Record{}
    params = %{title: title, artist_id: artist_id}

    record
    |> Record.changeset(params)
    |> insert()
  end

  def insert_artist(%Artist{name: name, birthday: birthday, sex: sex}) do
    artist = %Artist{}
    params = %{name: name, birthday: birthday, sex: sex}

    artist
    |> Artist.changeset(params)
    |> insert()
  end

  def insert_song(%Song{
        title: title,
        runtime: runtime,
        artist_id: artist_id,
        record_id: record_id
      }) do
    song = %Song{}
    params = %{title: title, runtime: runtime, artist_id: artist_id, record_id: record_id}

    song
    |> Song.changeset(params)
    |> insert()
  end

  def insert_record_into_collection(record_id, collection_id) do
    records_in_collection = %RecordsInCollection{}
    params = %{record_id: record_id, collection_id: collection_id}

    records_in_collection
    |> RecordsInCollection.changeset(params)
    |> insert()
  end

  def get_collections(library_id) do
    Collection
    |> where([c], c.library_id == ^library_id)
    |> all()
  end

  def search_collections(library_id, search_term) do
    term = "%#{String.downcase(search_term)}%"

    Collection
    |> where([c], c.library_id == ^library_id and fragment("like(lower(?), ?)", c.name, ^term))
    |> all()
  end

  def get_collection(collection_id) do
    Collection
    |> get_by(id: collection_id)
    |> preload(:records)
  end

  def get_record(record_id) do
    Record
    |> get(record_id)
    |> preload(:artist)
    |> preload(:songs)
  end

  def get_records do
    Record
    |> all()
    |> preload(:artist)
    |> preload(:songs)
  end

  def get_library(user_id) do
    Library
    |> get_by(user_id: user_id)
    |> preload(:collections)
  end

  def get_user(email) do
    User
    |> get_by(email: email)
  end

  def get_artist(artist_name) do
    Artist
    |> get_by(name: artist_name)
  end

  def get_artists do
    Artist
    |> all()
  end
end
