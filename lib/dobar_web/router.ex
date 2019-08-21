defmodule DobarWeb.Router do
  use DobarWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :maybe_browser_auth do
    plug Guardian.Plug.Pipeline,
      module: DobarWeb.Auth.Guardian,
      error_handler: DobarWeb.Admin.AuthErrorHandler

    plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
    plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
    plug(Guardian.Plug.LoadResource, allow_blank: true)
  end

  pipeline :ensure_admin_access do
    plug(Guardian.Plug.EnsureAuthenticated,
      claims: %{"typ" => "access"},
      error_handler: DobarWeb.Admin.AuthErrorHandler
    )
  end

  pipeline :admin_layout do
    plug :put_layout, {DobarWeb.LayoutView, :admin}
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

  scope "/admin", DobarWeb.Admin, as: :admin do
    pipe_through([:browser, :maybe_browser_auth, :admin_layout])
    get("/login", AuthController, :index)
    post("/login", AuthController, :login)
    get("/logout", AuthController, :logout)

    pipe_through :ensure_admin_access
    get("/", DashboardController, :index)

    resources "/places", PlaceController do
      resources "/images", PlaceImageController
    end

    resources "/users", UserController
  end

  scope "/api" do
    pipe_through [:api, :graphql]

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: DobarWeb.Schema
    forward "/", Absinthe.Plug, schema: DobarWeb.Schema
  end

  scope "/", DobarWeb do
    # Use the default browser stack
    pipe_through :browser

    get "/*path", HomeController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", DobarWeb do
  #   pipe_through :api
  # end
end
