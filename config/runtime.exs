import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.
if config_env() in [:prod, :dev] do
  # database_url =
  #   System.get_env("DATABASE_URL", "localhost") ||
  #     raise """
  #     environment variable DATABASE_URL is missing.
  #     For example: ecto://USER:PASS@HOST/DATABASE
  #     """

  # config :live_k8s, LiveK8s.Repo,
  #   # ssl: true,
  #   # socket_options: [:inet6],
  #   url: database_url,
  #   pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  # config :live_k8s, LiveK8sWeb.Endpoint,
  #   http: [
  #     url: [host: "localhost"],
  #     secret_key_base: "81mJnB8ssm8pSsogwShfDMwNrl0utoHAlYCBXaKJPn7HBYmZ7mSJ2PN+fFusXeYM",
  #     # Enable IPv6 and bind on all interfaces.
  #     # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
  #     # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
  #     # for details about using IPv6 vs IPv4 and loopback vs public addresses.
  #     ip: {0, 0, 0, 0, 0, 0, 0, 0},
  #     port: String.to_integer(System.get_env("PORT") || "4000")
  #   ],
  #   pubsub_server: LiveK8s.PubSub,
  #   live_view: [signing_salt: "riu/KFce"]
  #   server: true,
  #   secret_key_base: "81mJnB8ssm8pSsogwShfDMwNrl0utoHAlYCBXaKJPn7HBYmZ7mSJ2PN+fFusXeYM"

  # service_name = System.fetch_env!("SERVICE_NAME")

  # config :libcluster,
  #   topologies: [
  #     k8s_dns: [
  #       strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
  #       config: [
  #         service: service_name,
  #         application_name: "live_k8s",
  #         polling_interval: 10_000
  #       ]
  #     ]
  #   ]

  config :live_k8s, LiveK8sWeb.Endpoint,
    http: [port: System.get_env("PORT", "4000") |> String.to_integer()],
    secret_key_base: "81mJnB8ssm8pSsogwShfDMwNrl0utoHAlYCBXaKJPn7HBYmZ7mSJ2PN+fFusXeYM",
    render_errors: [view: LiveK8sWeb.ErrorView, accepts: ~w(html json), layout: false],
    pubsub_server: LiveK8s.PubSub,
    debug_errors: true,
    check_origin: false,
    server: true,
    live_view: [signing_salt: "riu/KFce"]

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  # config :live_k8s, LiveK8sWeb.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :live_k8s, LiveK8s.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
end
