defmodule Dobar.Repo.Migrations.AddUniqIndex do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:username], name: :users_username_uniq_idx)
  end
end
