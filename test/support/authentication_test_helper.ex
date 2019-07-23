defmodule Dobar.AuthenticationTestHelper do
  alias DobarWeb.Auth.Guardian

  def authenticate_user(conn, user) do
    {:ok, token, _} = Guardian.encode_and_sign(user, token_type: :access)

    conn
    |> Plug.Conn.put_req_header("authorization", "Bearer #{token}")
  end
end
