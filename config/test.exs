use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gate_goat, GateGoatWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :gate_goat, GateGoat.Repo,
  username: "postgres",
  password: "postgres",
  database: "gate_goat_dev",
  hostname: "gate_goat_pg",
  pool: Ecto.Adapters.SQL.Sandbox
