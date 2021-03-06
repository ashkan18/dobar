# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dobar,
  ecto_repos: [Dobar.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :dobar, DobarWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pPPRcgwiAobIQOnknWrmEOJ59RX9EVvxYCXHxTRm6zub0S+qroIu8uR/s92jZ3Dj",
  render_errors: [view: DobarWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Dobar.PubSub, adapter: Phoenix.PubSub.PG2]

config :dobar, Dobar.Repo, types: Dobar.PostgresTypes

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :dobar, DobarWeb.Auth.Guardian,
  # Name of your app/company/product
  issuer: "dobar",
  secret_key: "uGV84HYOnL45wwxgNUUsEj9V82RNxp8xCzUWLuA+KO/eiLbNw+Tfs4EVFcy8JJjv"

config :arc,
  storage: Arc.Storage.S3,
  bucket: {:system, "AWS_S3_BUCKET"}

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role]

config :geocoder, :worker_pool_config, size: 4, max_overflow: 2

config :geocoder, :worker,
  # OpenStreetMaps or OpenCageData are other supported providers
  provider: Geocoder.Providers.GoogleMaps,
  key: System.get_env("GEOCODER_GOOGLE_API_KEY")

config :dobar, Dobar.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.get_env("SMTP_API_KEY"),
  # can be `:always` or `:never`
  tls: :if_available,
  # can be `true`
  ssl: false,
  retries: 1

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
