defmodule Timeline.Main do

  def new() do
    %{
      moves: [],
    }
  end

  def add(t, new) do
    moves = t.moves ++ [new]
    Map.put(t, :moves, moves)
  end

  def ascii_output(t) do
    # if t.moves == ["1"] do
    #   [
    # else
    #   []
    # end
    t.moves
  end
end
