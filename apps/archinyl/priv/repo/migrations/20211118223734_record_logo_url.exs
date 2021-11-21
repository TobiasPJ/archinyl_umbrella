defmodule Archinyl.Repo.Migrations.RecordLogoUrl do
  use Ecto.Migration

  def change do
    alter table(:record) do
      add :logo_url, :text
    end
  end
end
