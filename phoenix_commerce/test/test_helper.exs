Application.ensure_all_started(:hound)
ExUnit.start
Ecto.Adapters.SQL.Sandbox.mode(PhoenixCommerce.Repo, {:shared, self()})
{:ok, _} = Application.ensure_all_started(:hound)


ExUnit.configure(exclude: [external: true])
