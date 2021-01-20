defmodule Timeline.Main do

  def new() do
    %{
      moves: [],
    }
  end

  # manual_id override for testing; expect errors if ID's repeated
  def add(t, new, manual_id \\ nil) do
    moves = t.moves ++ [new]
    Map.put(t, :moves, moves)
  end

  def value(_t, _id) do
    "cat"
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
