defmodule Archinyl.Schema.RecordsInCollection do
  use Ecto.Schema

  import Ecto.Changeset

  alias Archinyl.Schema.Record
  alias Archinyl.Schema.Collection

  @parameters [:record_id, :collection_id]

  schema "records_in_collection" do
    belongs_to :record, Record
    belongs_to :collection, Collection
  end

  def changeset(records_in_collection, params \\ %{}) do
    records_in_collection
    |> cast(params, @parameters)
    |> unique_constraint([:record, :collection], name: :unique_record_and_collection)
    |> foreign_key_constraint(:record_id)
    |> foreign_key_constraint(:collection_id)
  end

end
