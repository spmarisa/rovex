defmodule Rover do
  use GenServer

  defstruct [:x, :y, :direction, :name]

  def start_link({x, y, direction, name}) do
    GenServer.start_link(__MODULE__, {x, y, direction, name}, name: String.to_atom(name))
  end

  def init({x, y, direction, name}) do
    {:ok, %Rover{x: x, y: y, direction: direction, name: name }}
  end

  def get_state(name) do
    GenServer.call(String.to_atom(name), :get_state)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, {:ok, {state.x, state.y, state.direction}}, state}
  end

end
