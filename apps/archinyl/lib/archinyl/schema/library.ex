defmodule Archinyl.Schema.Library do
  use Ecto.Schema

  import Ecto.Changeset

  alias Archinyl.Schema.Library
  alias Archinyl.Schema.User
  alias Archinyl.Schema.Collection

  @parameters [:user_id]

  schema "library" do
    belongs_to :user, User
    has_many :collections, Archinyl.Schema.Collection, on_replace: :delete
  end

  def changeset(library, params \\ %{}) do
    library
    |> cast(params, @parameters)
    |> validate_required(@parameters)
    |> foreign_key_constraint(:user_id)
  end

  def changeset_insert_collection(%Library{} = library, collection_name) do
    collection = %Collection{name: collection_name}

    library
    |> cast(%{}, @parameters)
    |> put_assoc(:collections, library.collections ++ [collection])
  end

  def changeset_remove_collection(%Library{} = library, collection_id) do
    collection = Archinyl.Repo.get_by(Collection, id: collection_id)

    library
    |> cast(%{}, @parameters)
    |> put_assoc(:collections, library.collections -- [collection])
  end
end
