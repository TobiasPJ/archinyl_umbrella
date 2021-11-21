defmodule Archinyl.Schema.Record do
  use Ecto.Schema

  import Ecto.Changeset

  alias Archinyl.Schema.Artist

  @parameters [:title, :artist_id, :logo_url]

  schema "record" do
    field :title, :string
    field :logo_url, :string

    belongs_to :artist, Artist

    has_many :songs, Archinyl.Schema.Song
  end

  def changeset(record, params \\ %{}) do
    record
    |> cast(params, @parameters)
    |> validate_required(@parameters)
    |> foreign_key_constraint(:artist_id)
  end

  def changeset_insert_songs(record, songs) do
    record
    |> cast(%{}, @parameters)
    |> put_assoc(:songs, record.songs ++ songs)
  end
end
