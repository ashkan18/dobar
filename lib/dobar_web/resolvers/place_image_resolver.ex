defmodule DobarWeb.Resolvers.PlaceImageResolver do
  alias Dobar.Places

  def imageUrl(placeImage, args, _resolution) do
    {:ok, Dobar.PlaceImageUploader.url({placeImage.original_url, %{id: placeImage.place_id}}, String.to_atom(args.type))}
  end
end
