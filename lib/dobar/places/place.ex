defmodule Dobar.Places.Place do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "places" do
    field :accepts_card, :boolean
    field :address, :string
    field :address2, :string
    field :city, :string
    field :country, :string
    field :delivery, :boolean
    field :description, :string
    field :facebook, :string
    field :good_for_groups, :boolean
    field :instagram, :string
    field :location, Geo.PostGIS.Geometry
    field :logo_url, :string
    field :name, :string
    field :neighborhood, :string
    field :outdoor_seating, :boolean
    field :parking, :boolean
    field :phone, :string
    field :postal_code, :string
    field :price_range, :integer
    field :short_description, :string
    field :smoking, :boolean
    field :state, :string
    field :tags, {:array, :string}
    field :takes_reservation, :boolean
    field :twitter, :string
    field :website, :string
    field :weelchaire_accessible, :boolean
    field :wifi, :boolean
    field :working_hours, {:array, :string}

    has_many :reviews, Dobar.Reviews.Review
    has_many :images, Dobar.Places.PlaceImage

    timestamps()
  end

  @required_fields ~w(name description address city state country location)a
  @optional_fields ~w(price_range postal_code short_description address2 neighborhood website logo_url working_hours wifi weelchaire_accessible tags twitter website takes_reservation phone parking outdoor_seating good_for_groups accepts_card)a

  @doc false
  def changeset(place, attrs) do
    place
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
