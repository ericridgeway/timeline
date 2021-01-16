defmodule Timeline.Main do

  defstruct ~w[history]a

  def new() do
    struct!(__MODULE__,
      history: MapSet.new(),
    )
  end

  def add(t, new) do
    history = MapSet.put(t.history, new)
    t |> update_history(history)
  end

  def history(t), do: t.history |> MapSet.to_list

  defp update_history(t, new), do: struct!(t, history: new)
end
