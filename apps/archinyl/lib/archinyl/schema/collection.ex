defmodule Archinyl.Schema.Collection do
  use Ecto.Schema

  import Ecto.Changeset

  alias Archinyl.Schema.Collection

  @parameters [:library, :name]

  schema "collection" do
    field :name, :string, [null: :false]

    belongs_to :library, Collection
  end

  def changeset(collection, params \\ %{}) do
    collection
    |> cast(params, @parameters)
    |> validate_required(@parameters)
  end

end
