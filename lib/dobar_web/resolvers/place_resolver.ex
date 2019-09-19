defmodule DobarWeb.Resolvers.PlaceResolver do
  alias Dobar.{Places}

  def find_places(parent, args = %{address: address}, resolution) do
    with {:ok, %{lat: lat, lon: lon}} <- Geocoder.call(address, components: "country:us") do
      args =
        args
        |> Map.delete(:address)
        |> Map.put(:location, %{lat: lat, lng: lon})

      find_places(parent, args, resolution)
    else
      _ -> {:error, "Unknown address"}
    end
  end

  def find_places(_parent, args, _resolution) do
    Places.find_places(args)
    |> Absinthe.Relay.Connection.from_list(args)
  end

  def find_place(_parent, args, _resolution) do
    {:ok, Places.get_place!(args.id)}
  end

  def upload_place_photo(_parent, %{place_id: place_id, photo: photo}, %{
        context: %{current_user: current_user}
      }) do
    Places.upload_place_image(%{
      place_id: place_id,
      photo_file: photo,
      uploader_id: current_user.id
    })
  end

  def upload_place_photo(_parent, _args, _context), do: {:error, "Not Authorized"}
end
