defmodule Dobar.Repo.Migrations.CreatePlaceImages do
  use Ecto.Migration

  def change do
    create table(:place_images, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :original_url, :string
      add :place_id, references(:places, on_delete: :nothing, type: :binary_id)
      add :uploader_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:place_images, [:place_id])
    create index(:place_images, [:uploader_id])
  end
end
