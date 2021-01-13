defmodule Timeline.Main do

  def new() do
    %{
      me: [],
      cur_move: 0,
    }
  end

  def add(t, new) do
    t
    |> update_me([new | t.me])
    |> update_cur_move(t.cur_move + 1)
  end

  def history(t), do: t.me |> Enum.reverse()


  defp update_me(t, new), do: Map.put(t, :me, new)
  defp update_cur_move(t, new), do: Map.put(t, :cur_move, new)
end
