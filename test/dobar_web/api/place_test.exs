defmodule DobarWeb.PlaceTest do
  use DobarWeb.ConnCase, async: true
  alias Dobar.Fixtures

  @query """
  query places($location: LocationInput, $first: Int){
    places(location: $location, first: $first){
      edges {
        node {
          id
        }
      }
    }
  }
  """

  setup do
    [
      good_burger:
        Fixtures.create(:place,
          lat: 40.6602037,
          lng: -73.9711445,
          name: "Good Burger"
        ),
      khoob_burger:
        Fixtures.create(:place,
          lat: 40.6843493,
          lng: -73.988664,
          name: "Khoob Burger"
        )
    ]
  end

  test "Logins successfully and returns token", context do
    response =
      build_conn()
      |> graphql_query(
        query: @query,
        variables: %{
          location: %{
            lat: 40.6843493,
            lng: -73.9886644,
          },
          first: 10
        }
      )
    assert Enum.map(response["data"]["places"]["edges"], fn p -> p["node"]["id"] end) == [context.good_burger.id, context.khoob_burger.id]
  end
end
