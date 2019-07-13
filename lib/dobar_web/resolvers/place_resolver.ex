defmodule DobarWeb.Resolvers.PlaceResolver do
  alias Dobar.Places
  def find_places(_parent, args, _resolution) do
    %{lat: lat, lng: lng} = args
    {:ok,
      Places.find_places(%{lat: lat, lng: lng})
      |> Absinthe.Relay.Connection.from_list(args)
    }
  end
end