defmodule AltTicTac1.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(AltTicTac1.Web.Endpoint, []),
      # Start your own worker by calling: AltTicTac1.Worker.start_link(arg1, arg2, arg3)
      # worker(AltTicTac1.Worker, [arg1, arg2, arg3]),
      supervisor(AltTicTac1.RoundSupervisor, []),
      supervisor(Registry, [:unique, AltTicTac1.RoundRegistry])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AltTicTac1.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
