defmodule Overload.Repo do
  use Ecto.Repo,
    otp_app: :overload,
    adapter: Ecto.Adapters.Postgres
end
