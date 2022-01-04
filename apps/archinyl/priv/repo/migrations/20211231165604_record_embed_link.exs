defmodule Archinyl.Repo.Migrations.RecordEmbedLink do
  use Ecto.Migration

  def change do
    alter table(:record) do
      add :embed_link, :text
    end
  end
end
