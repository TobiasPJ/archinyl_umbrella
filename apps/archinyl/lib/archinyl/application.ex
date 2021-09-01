defmodule Archinyl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Archinyl.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Archinyl.PubSub}
      # Start a worker by calling: Archinyl.Worker.start_link(arg)
      # {Archinyl.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Archinyl.Supervisor)
  end
end
