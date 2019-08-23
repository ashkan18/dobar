defmodule Dobar.Social.PlaceInvite do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "place_invite" do
    field :guest_email, :string
    field :status, :string, default: "pending"
    belongs_to :host, Dobar.Accounts.User
    belongs_to :place, Dobar.Places.Place

    timestamps()
  end

  @required_fields ~w(place_id host_id guest_email status)a
  @statuses ~w(pending accepted rejected done)

  @doc false
  def changeset(place_invite, attrs) do
    place_invite
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:status, @statuses)
    |> foreign_key_constraint(:place_id)
    |> foreign_key_constraint(:user_id)
  end
end
