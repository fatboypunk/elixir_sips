defmodule PhoenixCommerce.AcceptanceCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      @moduletag :acceptance

      use Hound.Helpers

      import Ecto.Query
      import PhoenixCommerce.Router.Helpers

      alias PhoenixCommerce.Repo
      alias PhoenixCommerce.Web.Endpoint

      hound_session()
    end
  end


  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PhoenixCommerce.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(PhoenixCommerce.Repo, {:shared, self()})
    end

    :ok
  end
end
