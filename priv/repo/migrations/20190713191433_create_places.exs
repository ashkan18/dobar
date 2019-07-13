defmodule Dobar.Repo.Migrations.CreatePlaces do
  use Ecto.Migration

  def change do
    create table(:places, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :short_description, :string
      add :description, :string
      add :location, :geometry
      add :address, :string
      add :address2, :string
      add :city, :string
      add :state, :string
      add :country, :string
      add :postal_code, :string
      add :logo_url, :string
      add :neighborhood, :string
      add :website, :string
      add :price_range, :integer

      timestamps()
    end

  end
end
