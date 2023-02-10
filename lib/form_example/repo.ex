defmodule FormExample.Repo do
  use Ecto.Repo,
    otp_app: :form_example,
    adapter: Ecto.Adapters.Postgres
end
