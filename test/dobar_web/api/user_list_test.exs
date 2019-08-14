defmodule DobarWeb.UserListTest do
  use DobarWeb.ConnCase, async: true
  alias Dobar.Fixtures

  @add_to_list_mutation """
  mutation add_to_list($placeId: ID!, $listType: String!){
    add_to_list(placeId: $placeId, listType: $listType){
      id
      listType
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

  describe "add_to_list" do
    test "retuern not authenticated", context do
      response =
        build_conn()
        |> graphql_query(
          query: @add_to_list_mutation,
          variables: %{
            placeId: context.place.id,
            listType: "planning_to_go"
          }
        )

      assert [%{"message" => "Not Authorized"}] = response["errors"]
    end

    test "Logins successfully and returns token", context do
      response =
        build_conn()
        |> authenticate_user(context.user)
        |> graphql_query(
          query: @add_to_list_mutation,
          variables: %{
            placeId: context.place.id,
            listType: "planning_to_go"
          }
        )

      assert response["data"]["add_to_list"]["listType"] == "planning_to_go"
    end
  end
end
