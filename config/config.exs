# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :alt_tic_tac1, AltTicTac1.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rZb/NSeO+mfEgsQ6pU5O7XgjxhyvY5x6Uqc9ULXIA260kdw2ExV265hs9139Muj2",
  render_errors: [view: AltTicTac1.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AltTicTac1.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
