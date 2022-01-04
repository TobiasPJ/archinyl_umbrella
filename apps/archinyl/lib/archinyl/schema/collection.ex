defmodule Archinyl.Schema.Collection do
  use Ecto.Schema

  import Ecto.Changeset

  alias Archinyl.Schema.Library
  alias Archinyl.Schema.Record
  alias Archinyl.Schema.RecordsInCollection

  @parameters [:library_id, :name]

  schema "collection" do
    field :name, :string, null: false

    belongs_to :library, Library

    many_to_many :records, Record, join_through: RecordsInCollection, on_replace: :delete
  end

  def changeset(collection, params \\ %{}) do
    collection
    |> cast(params, @parameters)
    |> validate_required(@parameters)
    |> foreign_key_constraint(:library_id)
  end

  def update_records_in_collection(collection, record) do
    collection
    |> cast(%{}, @parameters)
    |> put_assoc(:records, collection.records ++ [record])
    |> unique_constraint(:records)
  end

  def remove_record_from_collection(collection, record) do
    collection
    |> cast(%{}, @parameters)
    |> put_assoc(:records, collection.records -- [record])
  end
end
