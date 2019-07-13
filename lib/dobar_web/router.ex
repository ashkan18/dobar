defmodule DobarWeb.Router do
  use DobarWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :graphql do
    plug DobarWeb.Auth.GraphQLContextPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
      pass: ["*/*"],
      json_decoder: Jason

    plug Guardian.Plug.Pipeline,
      module: DobarWeb.Auth.Guardian,
      error_handler: DobarWeb.Auth.ErrorHandler

    plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
    plug(Guardian.Plug.LoadResource, allow_blank: true)
  end

  scope "/", DobarWeb do
    pipe_through :browser

    get "/", HomeController, :index
  end

  scope "/api" do
    pipe_through [:api, :graphql]

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: DobarWeb.Schema
    forward "/", Absinthe.Plug, schema: DobarWeb.Schema
  end

  scope "/", DobarWeb do
    pipe_through :browser # Use the default browser stack

    get "/*path", HomeController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", DobarWeb do
  #   pipe_through :api
  # end
end
