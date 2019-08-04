defmodule DobarWeb.Schema.PlaceTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  @desc "A Place"
  object :place do
    field :id, :id
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
    field :location, :location
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
    field :tags, list_of(:string)
    field :takes_reservation, :boolean
    field :twitter, :string
    field :website, :string
    field :weelchaire_accessible, :boolean
    field :wifi, :boolean
    field :working_hours, list_of(:string)
  end

  input_object :location_input do
    field :lat, non_null(:float)
    field :lng, non_null(:float)
  end
end
