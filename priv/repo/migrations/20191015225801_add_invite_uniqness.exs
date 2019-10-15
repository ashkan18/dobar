defmodule Dobar.Repo.Migrations.AddInviteUniqness do
  use Ecto.Migration

  def change do
    create unique_index(:place_invite, [:host_id, :place_id, :guest_email], name: :place_invite_host_place_guest)
  end
end
