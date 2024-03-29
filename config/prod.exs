import Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
# config :live_k8s, LiveK8sWeb.Endpoint,
#   url: [host: "localhost", port: 4000],
#   cache_static_manifest: "priv/static/cache_manifest.json"

config :live_k8s, LiveK8sWeb.Endpoint,
  url: [host: "localhost", port: 4000],
  http: [ip: {127, 0, 0, 1}, port: 4000],
  secret_key_base: "81mJnB8ssm8pSsogwShfDMwNrl0utoHAlYCBXaKJPn7HBYmZ7mSJ2PN+fFusXeYM",
  render_errors: [view: LiveK8sWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveK8s.PubSub,
  debug_errors: true,
  check_origin: false,
  server: true,
  live_view: [signing_salt: "riu/KFce"]

# Do not print debug messages in production
config :logger, level: :debug

config :libcluster,
  topologies: [
    live_k8s: [
      strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
      config: [
        service: "live-k8s-nodes",
        application_name: "live_k8s"
      ]
    ]
  ]

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :live_k8s, LiveK8sWeb.Endpoint,
#       ...,
#       url: [host: "example.com", port: 443],
#       https: [
#         ...,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :live_k8s, LiveK8sWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.
