defmodule Archinyl.Schema.Record do
  use Ecto.Schema

  import Ecto.Changeset

  alias Archinyl.Schema.Artist

  @parameters [:title, :artist]

  schema "record" do
    field :title, :string

    belongs_to :artist, Artist
  end

  def changeset(record, params \\ %{}) do
    record
    |> cast(params, @parameters)
    |> validate_required(@parameters)
  end
end
