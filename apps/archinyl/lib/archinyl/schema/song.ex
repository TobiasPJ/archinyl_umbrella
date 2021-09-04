defmodule Archinyl.Schema.Song do
  use Ecto.Schema

  import Ecto.Changeset

  alias Archinyl.Schema.Artist
  alias Archinyl.Schema.Record

  @parameters [:title, :runtime, :artist_id, :record_id]

  schema "song" do
    field :title, :string
    field :runtime, :time

    belongs_to :artist, Artist
    belongs_to :record, Record
  end

  def changeset(song, params \\ %{}) do
    song
    |> cast(params, @parameters)
    |> validate_required(@parameters)
    |> foreign_key_constraint(:artist_id)
    |> foreign_key_constraint(:record_id)
  end
end
