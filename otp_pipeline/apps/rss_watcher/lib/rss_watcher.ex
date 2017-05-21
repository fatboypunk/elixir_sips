defmodule RssWatcher do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    IO.puts "wwwwwwwwwwwwwwwwwwwww"

    children = [
      worker(RssWatcher.FeedWatcher, ["https://www.reddit.com/new.rss"]),
    ]

    opts = [strategy: :one_for_one, name: RssWatcher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
