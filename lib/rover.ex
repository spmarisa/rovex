defmodule Rover do
  use GenServer

  defstruct [:x, :y, :direction, :name]
  @world_width 100
  @world_height 100

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

  def go_forward(name) do
    GenServer.cast(RegistryHelper.create_key(name), :go_forward)
  end

  def handle_cast(:go_forward, state) do
    new_state = case state.direction do
      :N -> %Rover{ state | x: state.x, y: Integer.mod(state.y + 1, @world_height) }
      :S -> %Rover{ state | x: state.x, y: Integer.mod(state.y - 1, @world_height) }
      :E -> %Rover{ state | x: Integer.mod(state.x + 1, @world_width), y: state.y }
      :W -> %Rover{ state | x: Integer.mod(state.x - 1, @world_width), y: state.y }
    end
    {:noreply, new_state}
  end

  def rotate_left(name) do
    GenServer.cast(RegistryHelper.create_key(name), :rotate_left)
  end

  def handle_cast(:rotate_left, state) do
    new_state = case state.direction do
      :N -> %Rover{state | direction: :W}
      :S -> %Rover{state | direction: :E}
      :E -> %Rover{state | direction: :N}
      :W -> %Rover{state | direction: :S}
    end
    {:noreply, new_state}
  end
end
