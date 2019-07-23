defmodule DobarWeb.ReviewTest do
  use DobarWeb.ConnCase, async: true
  alias Dobar.Fixtures

  @dobar_mutation """
  mutation dobar($placeId: ID!, $response: Boolean!){
    dobar(placeId: $placeId, response: $response){
      id
      reviewType
    }
  }
  """

  @rideshare_dobar_mutation """
  mutation rideshareDobar($placeId: ID!, $response: Boolean!){
    rideshareDobar(placeId: $placeId, response: $response){
      id
      reviewType
    }
  }
  """

  setup do
    [
      place:
        Fixtures.create(:place,
          lat: 40.6602037,
          lng: -73.9711445,
          name: "Good Burger"
        ),
      user:
        Fixtures.create(:user,
          username: "taster"
        )
    ]
  end

  describe "dobar" do
    test "retuern not authenticated", context do
      response =
        build_conn()
        |> graphql_query(
          query: @dobar_mutation,
          variables: %{
            placeId: context.place.id,
            response: true
          }
        )
      assert [%{"message" => "Not Authorized"}] = response["errors"]
    end

    test "Logins successfully and returns token", context do
      response =
        build_conn()
        |> authenticate_user(context.user)
        |> graphql_query(
          query: @dobar_mutation,
          variables: %{
            placeId: context.place.id,
            response: true
          }
        )
      assert response["data"]["dobar"]["reviewType"] == "dobar"
    end
  end

  describe "rideshare_dobar" do
    test "retuern not authenticated", context do
      response =
        build_conn()
        |> graphql_query(
          query: @rideshare_dobar_mutation,
          variables: %{
            placeId: context.place.id,
            response: true
          }
        )
      assert [%{"message" => "Not Authorized"}] = response["errors"]
    end

    test "Logins successfully and returns token", context do
      response =
        build_conn()
        |> authenticate_user(context.user)
        |> graphql_query(
          query: @rideshare_dobar_mutation,
          variables: %{
            placeId: context.place.id,
            response: true
          }
        )
      assert response["data"]["rideshareDobar"]["reviewType"] == "rideshare_dobar"
    end
  end
end
