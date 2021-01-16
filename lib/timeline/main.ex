defmodule Timeline.Main do
  alias Timeline.{Move}

  defstruct ~w[history turns]a

  def new() do
    %__MODULE__{
      history: MapSet.new(),
      turns: 0,
    }
  end

  def add(t, new) do
    t
    |> add_history(new)
    |> inc_turns()
  end

  def history(t) do
    t.history
    |> MapSet.to_list
    |> Enum.sort(&Move.sort/2)
    |> Enum.map(&Move.value/1)
  end

  def turns(t), do: t.turns

  defp add_history(t, new) do
    move = Move.new(t.turns+1, new)
    # struct!(t, history: MapSet.put(t.history, move))
    update_history(t, MapSet.put(t.history, move))
  end

  defp update_history(t, new), do: struct!(t, history: new)

  defp inc_turns(t), do: struct!(t, turns: t.turns + 1)
end
