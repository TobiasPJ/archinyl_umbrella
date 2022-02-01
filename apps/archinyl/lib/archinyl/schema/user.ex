defmodule Archinyl.Schema.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Archinyl.Schema.{Record, Likes}

  @parameters [:full_name, :username, :email, :noenc_password]

  schema "users" do
    field :full_name, :string
    field :username, :string
    field :email, :string
    field :password, :string
    field :noenc_password, :string, virtual: true

    many_to_many :likes, Record, join_through: Likes, on_replace: :delete
    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @parameters)
    |> unique_constraint(:email, name: :unique_email)
    |> validate_required(@parameters)
    |> validate_format(:email, ~r/@/)
  end

  def like_record(user, record) do
    user
    |> cast(%{}, @parameters)
    |> put_assoc(:likes, user.likes ++ [record])
  end

  def unlike_record(user, record) do
    user
    |> cast(%{}, @parameters)
    |> put_assoc(:likes, user.likes -- [record])
  end
end
