defmodule DobarWeb.SignupTest do
  use DobarWeb.ConnCase, async: true

  @query """
  mutation signup($username: String!, $password: String!, $passwordConfirmation: String!, $name: String!, $email: String!){
    signup(username: $username, password: $password, passwordConfirmation: $passwordConfirmation, name: $name, email: $email){
      token
    }
  }
  """
  test "Create user and returns token " do
    response =
      build_conn()
      |> graphql_query(
        query: @query,
        variables: %{
          username: "taster1",
          name: "Taste Tasterson",
          password: "1burger!beer",
          passwordConfirmation: "1burger!beer",
          email: "taste@taster.com"
        }
      )

    assert !is_nil(response["data"]["signup"]["token"])
  end
end
