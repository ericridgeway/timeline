defmodule Timeline.Main do

  def new() do
    %{
      me: [],
      cur_move: 3,
    }
  end

  def add(t, new) do
    update_me(t, [new | t.me])
  end

  def history(t), do: t.me |> Enum.reverse()


  defp update_me(t, new), do: Map.put(t, :me, new)
end
