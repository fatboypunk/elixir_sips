defmodule FeedEntryHandler do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(FeedEntryHandler.Handler, [])
    ]


    opts = [strategy: :one_for_one, name: FeedEntryHandler.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
