defmodule Archinyl.Repo do
  use Ecto.Repo,
    otp_app: :archinyl,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query, only: [where: 3, limit: 2, offset: 2, order_by: 2]

  alias Archinyl.Schema.{
    User,
    Library,
    Collection,
    Record,
    Artist,
    Song
  }

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

  def create_record(title, artist_id, embed_link, cover_url) do
    record = %Record{}
    params = %{title: title, artist_id: artist_id, logo_url: cover_url, embed_link: embed_link}

    record
    |> Record.changeset(params)
    |> insert()
  end

  def update_record_songs(record, songs) do
    record
    |> preload(:songs)
    |> Record.changeset_insert_songs(songs)
    |> update()
  end

  def insert_artist(name, birthday, sex, picture_url, description) do
    artist = %Artist{}

    params = %{
      name: name,
      birthday: birthday,
      sex: sex,
      picture_url: picture_url,
      description: description
    }

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

  def insert_record_into_collection(collection_id, record) do
    collection = get_by(Collection, id: collection_id)

    collection
    |> preload(:records)
    |> Collection.update_records_in_collection(record)
    |> update()
  end

  def remove_record_from_collection(collection, record_id) do
    record = get_by(Record, id: record_id) |> preload(:artist) |> preload(:songs)

    collection
    |> preload(:records)
    |> Collection.remove_record_from_collection(record)
    |> update()
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
    |> preload(records: [:artist, :songs])
  end

  def get_record(record_id) do
    Record
    |> get(record_id)
    |> preload(:artist)
    |> preload(:songs)
  end

  def get_records(search_term, limit, offset) do
    term = "%#{String.downcase(search_term)}%"

    total_count = aggregate(Record, :count, :id)

    records =
      Record
      |> where([r], fragment("like(lower(?), ?)", r.title, ^term))
      |> pagination(limit, offset)
      |> all()
      |> preload(:artist)
      |> preload(:songs)

    %{total_count: total_count, records: records}
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

  def get_artists(search_term, limit, offset) do
    term = "%#{String.downcase(search_term)}%"

    total_count = aggregate(Artist, :count, :id)

    artists =
      Artist
      |> where([r], fragment("like(lower(?), ?)", r.name, ^term))
      |> pagination(limit, offset)
      |> all()

    %{total_count: total_count, artists: artists}
  end

  def get_artist(id) do
    get(Artist, id)
  end

  def get_artists do
    Artist
    |> all()
  end

  def check_if_artist_exist(name, birthday) do
    term = "%#{String.downcase(name)}%"

    Artist
    |> where([a], fragment("like(lower(?), ?)", a.name, ^term) and a.birthday == ^birthday)
    |> exists?()
  end

  def update_artist(artist_id, new_data) do
    Artist
    |> get(artist_id)
    |> Ecto.Changeset.change(new_data)
    |> update()
  end

  defp pagination(query, limit, offset) do
    query
    |> order_by(desc: :id)
    |> limit(^limit)
    |> offset(^offset)
  end
end
