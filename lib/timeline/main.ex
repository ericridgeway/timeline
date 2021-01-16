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
    full_move_history(t)
    |> Enum.map(&Move.value/1)
  end

  # def history_with_parents(t) do
  #   t
  #   |> IO.inspect(label: "")
  #   if t.history |> MapSet.size == 1 do
  #     history(t)
  #     |> Enum.map(
  #   end
  # end

  def most_recent_move(t) do
    if t.history |> MapSet.size == 0 do
      nil
    else
      t |> full_move_history |> Enum.reverse |> hd
    end
  end

  def turns(t), do: t.turns


  defp full_move_history(t) do
    t.history
    |> MapSet.to_list
    |> Enum.sort(&Move.sort/2)
  end

  defp add_history(t, new) do
    move = Move.new(t.turns+1, new, most_recent_move(t))
    struct!(t, history: MapSet.put(t.history, move))
  end

  defp inc_turns(t), do: struct!(t, turns: t.turns + 1)
end
