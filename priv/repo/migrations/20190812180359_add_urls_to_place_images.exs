defmodule Dobar.Repo.Migrations.AddUrlsToPlaceImages do
  use Ecto.Migration

  def change do
    alter table(:place_images) do
      add :urls, :map
      drop :original_url
    end
  end
end
