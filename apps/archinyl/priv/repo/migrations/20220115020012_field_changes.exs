defmodule Archinyl.Repo.Migrations.FieldChanges do
  use Ecto.Migration

  def up do
    alter table(:artist) do
      remove :sex
      remove :birthday
    end

    alter table(:users) do
      modify :inserted_at, :timestamptz
      modify :updated_at, :timestamptz
    end
  end

  def down do
    alter table(:artist) do
      add :birthday, :date
      add :sex, :gender
    end

    alter table(:users) do
      modify :inserted_at, :naive_datetime
      modify :updated_at, :naive_datetime
    end
  end
end
