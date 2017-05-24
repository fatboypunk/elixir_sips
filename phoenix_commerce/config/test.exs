use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_commerce, PhoenixCommerce.Endpoint,
  http: [port: 4001],
  host: :localhost,
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phoenix_commerce, PhoenixCommerce.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "phoenix_commerce_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :hound, driver: "phantomjs",
  app_host: "http://localhost"
