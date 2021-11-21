defmodule LiveK8s.Repo do
  use Ecto.Repo,
    otp_app: :live_k8s,
    adapter: Ecto.Adapters.Postgres
end
