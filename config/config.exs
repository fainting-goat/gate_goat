# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :gate_goat,
  ecto_repos: [GateGoat.Repo]

# Configures the endpoint
config :gate_goat, GateGoatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cN75RS2xeeq97W9jxlCdPhr575bm/ZfuxdsYM3KzwHZxhs1DF4vtWJmEm6xEdORF",
  render_errors: [view: GateGoatWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GateGoat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
