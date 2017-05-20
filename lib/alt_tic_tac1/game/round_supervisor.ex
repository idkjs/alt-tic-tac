defmodule AltTicTac1.RoundSupervisor do
  use Supervisor

  def start_link do
   Supervisor.start_link(__MODULE__, [], name: :round_supervisor)
  end

  def init([]) do
    import Supervisor.Spec

    children = [
        worker(AltTicTac1.RoundServer, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

end