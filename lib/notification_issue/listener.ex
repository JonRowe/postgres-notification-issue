defmodule NotificationIssue.Listener do
  use GenServer

  @moduledoc """
  Uses Postgres's LISTEN/NOTIFY mechanism to observe changes made to the
  database and invokes publish with the raw payload from Postgres.
  """

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(_opts) do
    channel = "channelName"

    pg_config =
      [
        username: System.get_env("DB_USER"),
        password: System.get_env("DB_PASSWORD"),
        database: System.get_env("DB_NAME"),
        hostname: "localhost",
        port: "5432",
        pool_size: 10
      ]

    {:ok, pid} = Postgrex.Notifications.start_link(pg_config)
    {:ok, ref} = Postgrex.Notifications.listen(pid, channel)

    Logger.info "Postgrex listening to #{channel} as #{inspect pid}"
    {:ok, %{pid: pid, channel: channel, ref: ref}}
  end

  def handle_info({:notification, pid, ref, channel, message}, %{channel: channel, pid: pid, ref: ref} = state) do
    Logger.info "Notification received, #{channel}, #{message}"
    {:noreply, state}
  end

  def handle_info(something, state) do
    Logger.info "Unexpected message: #{something}"
    {:noreply, state}
  end
end
