defmodule DobarWeb.Schema.PlaceTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  @desc "A Place"
  object :place do
    field :id, :id
    field :address, :string
    field :address2, :string
    field :city, :string
    field :country, :string
    field :description, :string
    field :location, :location
    field :logo_url, :string
    field :name, :string
    field :neighborhood, :string
    field :postal_code, :string
    field :price_range, :integer
    field :short_description, :string
    field :state, :string
    field :website, :string
  end

  input_object :location_input do
    field :lat, non_null(:float)
    field :lng, non_null(:float)
  end
end
