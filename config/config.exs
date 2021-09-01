# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :archinyl,
  ecto_repos: [Archinyl.Repo]

config :archinyl_web,
  ecto_repos: [Archinyl.Repo],
  generators: [context_app: :archinyl]

# Configures the endpoint
config :archinyl_web, ArchinylWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wwEC5c+BpSBJWsV+qk1vMrOeNtSBobhY4lGzzEoi6B/Rb766fYTasPyMbSTARVR5",
  render_errors: [view: ArchinylWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Archinyl.PubSub,
  live_view: [signing_salt: "dj/xg75g"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
