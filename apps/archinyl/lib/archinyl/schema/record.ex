defmodule Archinyl.Schema.Record do
  use Ecto.Schema

  import Ecto.Changeset

  alias Archinyl.Schema.Artist

  @parameters [:title, :artist_id]

  schema "record" do
    field :title, :string

    belongs_to :artist, Artist
  end

  def changeset(record, params \\ %{}) do
    record
    |> cast(params, @parameters)
    |> validate_required(@parameters)
    |> foreign_key_constraint(:artist_id)
  end
end
