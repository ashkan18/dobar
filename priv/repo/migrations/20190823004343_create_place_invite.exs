defmodule Dobar.Repo.Migrations.CreatePlaceInvite do
  use Ecto.Migration

  def change do
    create table(:place_invite, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :guest_email, :string
      add :status, :string
      add :host_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :place_id, references(:places, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:place_invite, [:host_id])
    create index(:place_invite, [:place_id])
  end
end
