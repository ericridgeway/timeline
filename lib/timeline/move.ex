defmodule Timeline.Move do
  defstruct ~w[turn value]a

  def new(turn, value) do
    %__MODULE__{
      turn: turn,
      value: value,
    }
  end

  def sort(move1, move2) do
    move1.turn < move2.turn
  end

  def value(t), do: t.value
end
