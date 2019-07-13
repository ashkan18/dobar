defmodule Dobar.Places.Place do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "places" do
    field :address, :string
    field :address2, :string
    field :city, :string
    field :country, :string
    field :description, :string
    field :location, Geo.PostGIS.Geometry
    field :logo_url, :string
    field :name, :string
    field :neighborhood, :string
    field :postal_code, :string
    field :price_range, :integer
    field :short_description, :string
    field :state, :string
    field :website, :string

    timestamps()
  end

  @required_fields ~w(name short_description description address city state country postal_code location)a
  @optional_fields ~w(price_range address2 neighborhood website logo_url)a

  @doc false
  def changeset(place, attrs) do
    place
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
