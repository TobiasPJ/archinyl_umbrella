defmodule Archinyl.Schema.User do
  use Ecto.Schema

  import Ecto.Changeset

  @required_fields [:full_name, :username, :email, :noenc_password]

  schema "users" do
    field :full_name, :string
    field :username, :string
    field :email, :string
    field :password, :string
    field :noenc_password, :string, virtual: true
    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:full_name, :username, :email, :noenc_password])
    |> unique_constraint(:email, name: :unique_email)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
  end
end
