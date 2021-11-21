defmodule Archinyl.Schema.Artist do
  use Ecto.Schema

  import Ecto.Changeset

  @parameters [:name, :birthday, :sex, :picture_url, :description]

  schema "artist" do
    field(:name, :string, null: false)
    field(:birthday, :date)
    field(:sex, Ecto.Enum, values: [:male, :female, :other])
    field(:picture_url, :string)
    field(:description, :string)
  end

  def changeset(artist, params \\ %{}) do
    artist
    |> cast(params, @parameters)
    |> unique_constraint([:name, :birthday], name: :unique_artist)
  end
end
