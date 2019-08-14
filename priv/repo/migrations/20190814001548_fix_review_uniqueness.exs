defmodule Dobar.Repo.Migrations.FixReviewUniqueness do
  use Ecto.Migration

  def change do
    drop index(:reviews, [:place_id, :user_id], name: :reviews_place_id_user_id_uniq_idx)
    create unique_index(:reviews, [:place_id, :user_id, :review_type], name: :reviews_place_id_user_id_review_type_uniq_idx)
  end
end
