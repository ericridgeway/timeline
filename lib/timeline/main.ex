defmodule Timeline.Main do
  alias Timeline.{History}

  def new() do
    %{
      cur_move: 0,
      cur_timeline: 1,
      timeline: %{1 => History.new()},
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
    if any_redos?(t) do
      t |> update_cur_move(t.cur_move + 1)
    else
      t
    end
  end

  def any_redos?(t) do
    if t.cur_move == History.size(cur_history(t)), do: false, else: true
  end

  # def left(t) do
  #   t |> update_history(~w[a1 a2 a3])
  # end

  def cur_history(t) do
    Map.get(t.timeline, t.cur_timeline)
  end

  def cur_value(t) do
    cur_history(t) |> History.at(t.cur_move-1)
  end

  def history(t), do: cur_history(t)

  defp add_history(t, new) do
    t |> update_history(History.add(cur_history(t), new))
  end

  defp trim_history(t) do
    t |> update_history(History.trim(cur_history(t), t.cur_move))
  end

  defp update_history(t, new) do
    timeline = Map.put(t.timeline, t.cur_timeline, new)
    t |> update_timeline(timeline)
  end

  defp update_timeline(t, new), do: Map.put(t, :timeline, new)
  defp update_cur_move(t, new), do: Map.put(t, :cur_move, new)
end
