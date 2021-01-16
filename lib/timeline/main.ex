defmodule Timeline.Main do

  defstruct ~w[history turns]a

  def new() do
    struct!(__MODULE__,
      history: MapSet.new(),
      turns: 0,
    )
  end

  def add(t, new) do
    t
    |> add_history(new)
    |> inc_turns()
  end

  def history(t) do
    t.history
    |> MapSet.to_list
    |> Enum.sort(&(&1.turn < &2.turn))
    |> Enum.map(& &1.value)
  end

  def turns(t), do: t.turns

  defp add_history(t, new) do
    move = %{
      turn: t.turns+1,
      value: new,
    }
    struct!(t, history: MapSet.put(t.history, move))
  end

  defp inc_turns(t), do: struct!(t, turns: t.turns + 1)
end
