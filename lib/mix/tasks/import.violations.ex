defmodule Mix.Tasks.Import.Violation do
  use Mix.Task
  alias Dobar.Places

  @shortdoc "Imports NYC restaurants"

  @moduledoc """
    This is where we would put any long form documentation or doctests.
  """

  def run(_args) do
    Mix.Task.run("app.start")

    "./data/DOHMH_New_York_City_Restaurant_Inspection_Results.csv"
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Stream.map(&place_data/1)
    |> Stream.reject(&is_nil/1)
    |> Stream.chunk_every(500)
    |> Enum.map(&Places.bulk_create_place/1)
  end

  defp cleanup_name(name) do
    name |> String.capitalize() |> String.trim()
  end

  defp place_data(%{
    "DBA" => name,
    "Latitude" => lat,
    "Longitude" => lng,
    "ZIPCODE" => postal_code,
    "BUILDING" => building,
    "STREET" => street,
    "BORO" => boro,
    "PHONE" => phone,
    "CUISINE DESCRIPTION" => desc
  }) when byte_size(lat) > 0 and byte_size(lng) > 0 do
    %{
      name: cleanup_name(name),
      location: %Geo.Point{coordinates: {lat, lng}, srid: 4326},
      postal_code: postal_code,
      address: address(building, street),
      city: boro,
      country: "US",
      state: "NY",
      phone: phone,
      description: desc,
      tags: tags_from_string(desc),
      inserted_at: NaiveDateTime.utc_now |> NaiveDateTime.truncate(:second),
      updated_at: NaiveDateTime.utc_now |> NaiveDateTime.truncate(:second)
    }
  end
  defp place_data(_), do: nil

  defp tags_from_string(tags) do
    tags
    |> String.replace("(", ",")
    |> String.replace(")", "")
    |> String.replace("/", ",")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
  end

  defp address(building, street) do
    street = street |> String.trim() |> String.capitalize()
    [building, street] |> Enum.join(" ")
  end
end
