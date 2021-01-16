defmodule Timeline.Move do
  defstruct ~w[turn value]a

  def new(turn, value) do
    struct!(__MODULE__,
      turn: turn,
      value: value,
    )
  end
end
