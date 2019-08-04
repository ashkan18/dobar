defmodule Dobar.Repo.Migrations.AddMoreFieldsToPlace do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :type, :string, default: "restaurant"
      add :phone, :string
      add :working_hours, {:array, :string}
      add :delivery, :boolean
      add :accepts_card, :boolean
      add :wifi, :boolean
      add :outdoor_seating, :boolean
      add :takes_reservation, :boolean
      add :good_for_groups, :boolean
      add :weelchaire_accessible, :boolean
      add :smoking, :boolean
      add :parking, :boolean
      add :instagram, :string
      add :facebook, :string
      add :twitter, :string
    end
  end
end
