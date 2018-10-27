# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :api,
  ecto_repos: [Api.Repo]

# Configures the endpoint
config :api, ApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TTriKGFPdRaGS+zLrvBiMq1CFy89n/Fs3YGMsz23oxd453J/xpmHvbi2WUhEGcey",
  render_errors: [view: ApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Api.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Guardian
config :api, Api.Guardian,
       issuer: "npune",
       verify_issuer: true,
       secret_key: "gDM5QdxZEmj9eYjhfbKinWtL0r/GY5aHKLZFzi6aedQthZ5AV1kiNXayU5wLNUX4"

config :arc,
  storage: Arc.Storage.Local
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
