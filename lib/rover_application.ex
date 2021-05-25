defmodule Rover.Application do
  use Application

  def start(_type, _args) do
    children = [Supervisor.child_spec({Registry, [keys: :unique, name:Rover.Registry]}, id: :rover_registry),
                Supervisor.child_spec({RoverSupervisor, []}, id: RoverSupervisor),
                Plug.Adapters.Cowboy.child_spec(:http, Rover.Web.Router, [], port: 3000),
                Supervisor.child_spec({WorldMap, []}, [])]
    opts = [strategy: :one_for_one, name: Application.Supervisor]

    opts = [strategy: :one_for_one, name: Application.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
        [
          {"/ws", Rover.Web.WsServer, []},
          {:_, Plug.Adapters.Cowboy.Handler, {Rover.Web.Router, []}}
        ]}
    ]
  end
end
