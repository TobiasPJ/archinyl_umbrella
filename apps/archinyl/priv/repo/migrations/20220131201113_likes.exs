defmodule Archinyl.Repo.Migrations.Likes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :user_id, references(:users), null: false
      add :record_id, references(:record), null: false
    end

    create unique_index(:likes, [:user_id, :record_id], name: :one_like_per_user_per_record)
    create index(:likes, :record_id)
  end
end
