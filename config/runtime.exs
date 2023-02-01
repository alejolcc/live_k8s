import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.
if config_env() in [:prod, :dev] do
  config :live_k8s, LiveK8sWeb.Endpoint,
    http: [port: System.get_env("PORT", "4000") |> String.to_integer()],
    secret_key_base: "81mJnB8ssm8pSsogwShfDMwNrl0utoHAlYCBXaKJPn7HBYmZ7mSJ2PN+fFusXeYM",
    render_errors: [view: LiveK8sWeb.ErrorView, accepts: ~w(html json), layout: false],
    pubsub_server: LiveK8s.PubSub,
    debug_errors: true,
    check_origin: false,
    server: true,
    live_view: [signing_salt: "riu/KFce"]
end
