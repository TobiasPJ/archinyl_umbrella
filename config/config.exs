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

config :archinyl, Archinyl.Spotify.Auth,
  client_id: "05877e9b80904a309fc8006c846b555c",
  client_secret: "934b13f652c14f2ba7d153a9d2bba9f4"

config :archinyl, Archinyl.LastFM.Request,
  api_key: "646bd891ae12c15453636f5856b0d49c",
  shared_secret: "3a725254e9374bbd672f4616a8b161c5"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
