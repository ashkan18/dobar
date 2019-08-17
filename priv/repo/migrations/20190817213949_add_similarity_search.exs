defmodule Dobar.Repo.Migrations.AddSimilaritySearch do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm"
    execute "CREATE INDEX place_name_similarity_idx ON places USING gist (name gist_trgm_ops)"
  end
end
