defmodule DobarWeb.Admin.DashboardController do
  use DobarWeb, :controller

  def index(conn, _params), do: render(conn, "index.html")
end
