defmodule Timeline.Main do

  def new() do
    %{
      history: [],
      cur_move: 0,
    }
  end

  def add(t, new) do
    t
    |> trim_history()
    |> add_history(new)
    |> update_cur_move(t.cur_move + 1)
  end

  def undo(t) do
    if any_undos?(t) do
      t |> update_cur_move(t.cur_move - 1)
    else
      t
    end
  end

  def any_undos?(%{cur_move: 0}), do: false
  def any_undos?(_t), do: true

  def redo(t) do
    t |> update_cur_move(t.cur_move + 1)
  end

  def cur_value(t) do
    t.history |> Enum.at(t.cur_move-1)
  end

  def history(t), do: t.history

  defp add_history(t, new) do
    t |> update_history(t.history ++ [new])
  end

  defp trim_history(t) do
    t |> update_history(t.history |> Enum.take(t.cur_move))
  end

  defp update_history(t, new), do: Map.put(t, :history, new)
  defp update_cur_move(t, new), do: Map.put(t, :cur_move, new)
end
