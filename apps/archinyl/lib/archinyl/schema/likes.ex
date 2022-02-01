defmodule Archinyl.Schema.Likes do
  use Ecto.Schema

  import Ecto.Changeset

  alias Archinyl.Schema.{Record, User}

  @parameters [:user_id, :collection_id]

  schema "likes" do
    belongs_to :record, Record
    belongs_to :user, User
  end

  def changeset(likes, params \\ %{}) do
    likes
    |> cast(params, @parameters)
    |> unique_constraint([:record, :user], name: :one_like_per_user_per_record)
    |> foreign_key_constraint(:record_id)
    |> foreign_key_constraint(:user_id)
  end
end
