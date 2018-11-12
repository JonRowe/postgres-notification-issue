defmodule NotificationIssue do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link(
      [
        worker(NotificationIssue.Listener, [[]])
      ],
      strategy: :one_for_one,
      name: NotificationListener.Supervisor
    )
  end
end
