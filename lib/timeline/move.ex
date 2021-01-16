defmodule Timeline.Move do
  defstruct ~w[turn value parent]a

  def new(turn, value, parent \\ nil) do
    %__MODULE__{
      turn: turn,
      value: value,
      parent: parent,
    }
  end

  def sort(move1, move2) do
    move1.turn < move2.turn
  end

  def value(t), do: t.value
end
