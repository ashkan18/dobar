defmodule DobarWeb.Schema.PlaceTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  alias DobarWeb.Resolvers.ReviewResolver

  @desc "Place stats"
  object :stats do
    field :response, :boolean
    field :type, :string
    field :total, :integer
  end

  @desc "Image urls for a PlaceImage"
  object :image_urls do
    field :thumb, :string do
      resolve fn image_urls, _, _ ->
        {:ok, image_urls["thumb"]}
      end
    end
    field :original, :string do
      resolve fn image_urls, _, _ ->
        {:ok, image_urls["original"]}
      end
    end
  end

  @desc "A Place Image"
  object :place_image do
    field :id, :id
    field :urls, :image_urls
    field :place_id, :id
    field :uploader_id, :id
  end

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
    field :images, list_of(:place_image)
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
    field :stats, list_of(:stats) do
      resolve(&ReviewResolver.place_stats/3)
    end
    field :rideshare_dobar_count, :integer
  end

  input_object :location_input do
    field :lat, non_null(:float)
    field :lng, non_null(:float)
  end
end
