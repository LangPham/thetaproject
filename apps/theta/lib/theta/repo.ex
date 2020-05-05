defmodule Theta.Repo do
  use Ecto.Repo,
    otp_app: :theta,
    adapter: Ecto.Adapters.Postgres
end
