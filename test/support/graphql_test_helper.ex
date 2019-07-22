defmodule Dobar.GraphqlTestHelper do
  use Phoenix.ConnTest
  # We need to set the default endpoint for ConnTest
  @endpoint DobarWeb.Endpoint

  def graphql_query(conn, options) do
    conn
    |> post("/api/graphql", build_query(options[:query], options[:variables]))
    |> json_response(200)
  end

  defp build_query(query, variables) do
    %{
      "query" => query,
      "variables" => variables
    }
  end
end
