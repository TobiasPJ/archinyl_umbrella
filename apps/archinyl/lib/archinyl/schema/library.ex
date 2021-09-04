defmodule Archinyl.Schema.Library do
  use Ecto.Schema

  import Ecto.Changeset

  alias Archinyl.Schema.User

  @parameters [:user_id]

  schema "library" do
    belongs_to :user, User
  end

  def changeset(library, params \\ %{}) do
    library
    |> cast(params, @parameters)
    |> validate_required(@parameters)
    |> foreign_key_constraint(:user_id)
  end
end
