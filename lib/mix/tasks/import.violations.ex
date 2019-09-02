defmodule Mix.Tasks.Import.Violation do
  use Mix.Task
  alias Dobar.{Repo, Places}

  @shortdoc "Sends a greeting to us from Hello Phoenix"

  @moduledoc """
    This is where we would put any long form documentation or doctests.
  """

  def run(_args) do
    Mix.Task.run("app.start")
    "./data/DOHMH_New_York_City_Restaurant_Inspection_Results.csv"
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.take(3)
    |> IO.inspect
    |> Enum.map(&insert_violation/1)
  end

  defp insert_violation(claim) do
    business_name = claim["DBA"] |> String.capitalize
    case Places.get_place_by_name(business_name) do
      nil -> add_new(business_name, claim)
      _ -> IO.puts("would have updated")
    end
  end

  defp add_new(name, claim) do
    Places.create_place(%{
      "name" => name,
      "lat" => claim["Latitude"],
      "lng" => claim["Longitude"],
      "postal_code" => claim["ZIPCODE"],
      "address" => String.capitalize(claim["BUILDING"] <> " " <> claim["STREET"]),
      "city" => claim["BORO"],
      "country" => "US",
      "state" => "NY",
      "phone" => claim["PHONE"],
      "description" => claim["CUISINE DESCRIPTION"],
      "short_description" => ""
    }) |> IO.inspect
  end
end