Application.ensure_all_started(:hound)
ExUnit.start

# Mix.Task.run "ecto.drop", ~w(-r PhoenixCommerce.Repo --quiet)
Ecto.Adapters.SQL.Sandbox.mode(PhoenixCommerce.Repo, {:shared, self()})
# Ecto.Adapters.SQL.Sandbox.mode(PhoenixCommerce.Repo, :manual)

