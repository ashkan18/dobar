defmodule Dobar.AuthenticationTestHelper do
  alias DobarWeb.Auth.Guardian

  def authenticate_user(conn, user) do
    token = Guardian.encode_and_sign(user, token_type: :access)

    conn
    |> Plug.Conn.put_req_header("authorization", "Session #{token}")
  end
end
