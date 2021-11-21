defmodule Archinyl.Repo.Migrations.MoreArtistInformation do
  use Ecto.Migration

  def change do
    alter table(:artist) do
      add :picture_url, :text
      add :description, :text
    end
  end
end
