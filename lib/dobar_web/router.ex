defmodule DobarWeb.Router do
  use DobarWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DobarWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api" do
    pipe_through [:api]

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: ReadtomeWeb.Schema
    forward "/", Absinthe.Plug, schema: ReadtomeWeb.Schema
  end

  scope "/", ReadtomeWeb do
    pipe_through :browser # Use the default browser stack

    get "/*path", HomeController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", DobarWeb do
  #   pipe_through :api
  # end
end
