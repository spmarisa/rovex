defmodule RovexTest do
  use ExUnit.Case
  doctest Rovex

  test "get_state should return current state" do
     {:ok, _} = Rover.start_link({9, 9, :N, "rover0"})
     {:ok, state} = Rover.get_state("rover0")
     assert state == {9, 9, :N}
  end
end
