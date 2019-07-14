defmodule DobarWeb.Resolvers.PlaceResolver do
  alias Dobar.Places
  def find_places(_parent, args, _resolution) do
    Places.find_places(args)
    |> Absinthe.Relay.Connection.from_list(args)
  end
end