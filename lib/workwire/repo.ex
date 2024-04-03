defmodule Workwire.Repo do
  use Ecto.Repo,
    otp_app: :workwire,
    adapter: Ecto.Adapters.Postgres
end
