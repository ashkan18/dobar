defmodule Dobar.Repo.Migrations.CreateUserLists do
  use Ecto.Migration

  def change do
    create table(:user_lists, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :list_type, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :place_id, references(:places, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:user_lists, [:user_id])
    create index(:user_lists, [:place_id])
    create unique_index(:user_lists, [:place_id, :user_id, :list_type], name: :user_listss_place_id_user_id_type_uniq_idx)
  end
end
