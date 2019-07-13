use Mix.Config

# Configure your database
config :dobar, Dobar.Repo,
  database: "dobar_test",
  hostname: "localhost",
  adapter: Ecto.Adapters.Postgres,
  types: Dobar.PostgresTypes,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dobar, DobarWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
