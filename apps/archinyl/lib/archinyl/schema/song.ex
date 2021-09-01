defmodule Archinyl.Schema.Song do
  use Ecto.Schema

  import Ecto.Changeset

  alias Archinyl.Schema.Artist
  alias Archinyl.Schema.Record

  @parameters [:title, :runtime, :artist, :on_record]

  schema "song" do
    field :title, :string
    field :runtime, :time

    belongs_to :artist, Artist
    belongs_to :on_record, Record
  end

  def changeset(song, params \\ %{}) do
    song
    |> cast(params, @parameters)
    |> validate_required(@parameters)
  end
end
