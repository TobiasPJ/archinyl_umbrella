defmodule Archinyl.Schema.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :full_name, :string
    field :username, :string
    field :email, :string
    field :password, :string

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:full_name, :username, :email, :password])
    |> unique_constraint(:email, name: :unique_email)
    |> validate_required([:full_name, :username, :email, :password])
    |> validate_format(:email, ~r/@/)
  end
end
