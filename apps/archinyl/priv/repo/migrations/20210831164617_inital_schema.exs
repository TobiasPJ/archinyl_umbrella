defmodule Archinyl.Repo.Migrations.InitalSchema do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE gender AS ENUM ('female', 'male', 'other')"
    drop_query = "DROP TYPE gender"
    execute(create_query, drop_query)

    create table(:users) do
      add :full_name, :string, null: :false
      add :username, :string, null: :false
      add :email, :string, null: :false
      add :password, :string, null: :false

      timestamps()
    end

    create table(:library) do
      add :user_id, references(:users), null: :false
    end

    create table(:collection) do
      add :library_id, references(:library), null: :false
      add :name, :string, null: :false
    end

    create table(:artist) do
      add :name, :string, null: :false
      add :birthday, :date, null: :false
      add :sex, :gender, null: :false
    end

    create table(:record) do
      add :title, :string, null: :false
      add :artist_id, references(:artist), null: :false

    end

    create table(:records_in_collection) do
      add :record_id, references(:record), null: :false
      add :collection_id, references(:collection), null: :false
    end

    create table(:song) do
      add :record_id, references(:record), null: :false
      add :title, :string, null: :false
      add :runtime, :time, null: :false
      add :artist_id, references(:artist), null: :false
    end

    create unique_index(:artist, [:name, :birthday], name: :unique_artist)
    create unique_index(:users, [:email], name: :unique_email)
    create unique_index(:records_in_collection, [:record_id, :collection_id], name: :unique_record_and_collection)
  end
end
