defmodule Mix.Tasks.Import.Violation do
  use Mix.Task
  alias Dobar.{Repo, Places}

  @shortdoc "Imports NYC restaurants"

  @moduledoc """
    This is where we would put any long form documentation or doctests.
  """

  def run(_args) do
    Mix.Task.run("app.start")

    "./data/DOHMH_New_York_City_Restaurant_Inspection_Results.csv"
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.map(&insert_violation/1)
  end

  defp insert_violation(claim) do
    business_name = claim["DBA"] |> String.capitalize() |> String.trim()

    case Places.get_place_by_name(business_name) do
      nil -> add_new(business_name, claim)
      _ -> IO.puts("Duplicate: #{business_name}")
    end
  end

  defp add_new(name, %{
         "Latitude" => lat,
         "Longitude" => lng,
         "ZIPCODE" => postal_code,
         "BUILDING" => building,
         "STREET" => street,
         "BORO" => boro,
         "PHONE" => phone,
         "CUISINE DESCRIPTION" => desc
       })
       when byte_size(lat) > 0 and byte_size(lng) > 0 do
    Places.create_place(%{
      "name" => name,
      "lat" => lat,
      "lng" => lng,
      "postal_code" => postal_code,
      "address" => address(building, street),
      "city" => boro,
      "country" => "US",
      "state" => "NY",
      "phone" => phone,
      "description" => desc,
      "tags" => tags_from_string(desc)
    })
  end

  defp add_new(name, _), do: IO.puts("Ignoring #{name}")

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
