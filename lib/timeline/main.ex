defmodule Timeline.Main do

  defstruct ~w[history turns]a

  def new() do
    struct!(__MODULE__,
      history: MapSet.new(),
      turns: 0,
    )
  end

  def add(t, new) do
    history = MapSet.put(t.history, new)
    t
    |> update_history(history)
    |> inc_turns()
  end

  def history(t), do: t.history |> MapSet.to_list

  def turns(t), do: t.turns

  defp inc_turns(t), do: struct!(t, turns: t.turns + 1)
  defp update_history(t, new), do: struct!(t, history: new)
end
