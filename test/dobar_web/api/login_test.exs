defmodule DobarWeb.LoginTest do
  use DobarWeb.ConnCase, async: true
  alias Dobar.Fixtures

  @query """
  mutation login($username: String!, $password: String!){
    login(username: $username, password: $password){
      token
    }
  }
  """

  setup do
    [
      user:
        Fixtures.create(:user,
          username: "taster",
          password: "burger!beer",
          password_confirmation: "burger!beer"
        )
    ]
  end

  test "Logins successfully and returns token " do
    response =
      build_conn()
      |> graphql_query(
        query: @query,
        variables: %{
          username: "taster",
          password: "burger!beer"
        }
      )

    assert !is_nil(response["data"]["login"]["token"])
  end

  test "returns error for wrong password" do
    response =
      build_conn()
      |> graphql_query(
        query: @query,
        variables: %{
          username: "taster",
          password: "burgernobeer"
        }
      )

    assert is_nil(response["data"]["login"])
    assert [%{"message" => "Incorrect username or password"}] = response["errors"]
  end
end
