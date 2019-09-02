defmodule DobarWeb.Resolvers.PlaceResolver do
  alias Dobar.{Places, Repo}

  def find_places(_parent, args, _resolution) do
    Places.find_places(args)
    |> Repo.preload(:images)
    |> Absinthe.Relay.Connection.from_list(args)
  end

  def find_place(_parent, args, _resolution) do
    {:ok, Places.get_place!(args.id) |> Repo.preload(:images)}
  end

  def place_images(place, _args, _resolution) do
    place = Repo.preload(place, :images)
    {:ok, place.images}
  end
end
