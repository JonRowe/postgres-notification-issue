defmodule NotificationIssue.MixProject do
  use Mix.Project

  def project do
    [
      app: :notification_issue,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {NotificationIssue, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:postgrex, "~> 0.14.0"}
    ]
  end
end
