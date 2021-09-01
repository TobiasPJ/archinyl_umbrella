defmodule Archinyl.Schema.Library do
  use Ecto.Schema

  import Ecto.Changeset

  alias Archinyl.Schema.User

  @parameters [:library]

  schema "library" do
    belongs_to :users, User
  end

  def changeset(library, params \\ %{}) do
    library
    |> cast(params, @parameters)
    |> validate_required(@parameters)
  end
end
