# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :live_k8s,
  ecto_repos: [LiveK8s.Repo]

# Configure your database
config :live_k8s, LiveK8s.Repo,
  username: "postgres",
  password: "postgres",
  database: "live_k8s_dev",
  hostname: "postgres",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Configures the endpoint
config :live_k8s, LiveK8sWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "81mJnB8ssm8pSsogwShfDMwNrl0utoHAlYCBXaKJPn7HBYmZ7mSJ2PN+fFusXeYM",
  render_errors: [view: LiveK8sWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveK8s.PubSub,
  live_view: [signing_salt: "riu/KFce"]

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  level: :info,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
