defmodule Timeline.Main do

  def new() do
    %{
      history: [],
      cur_move: 0,
    }
  end

  def add(t, new) do
    t
    |> update_history(t.history ++ [new])
    |> update_cur_move(t.cur_move + 1)
  end

  def history(t), do: t.history


  defp update_history(t, new), do: Map.put(t, :history, new)
  defp update_cur_move(t, new), do: Map.put(t, :cur_move, new)
end
