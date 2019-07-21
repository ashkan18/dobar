defmodule Dobar.Repo.Migrations.CreatePlaceReviews do
  use Ecto.Migration

  def change do
    create table(:reviews, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :review_type, :string
      add :response, :boolean, default: false, null: false
      add :place_id, references(:places, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:reviews, [:place_id])
    create index(:reviews, [:user_id])
    create unique_index(:reviews, [:place_id, :user_id], :reviews_place_id_user_id_uniq_idx)
  end
end
