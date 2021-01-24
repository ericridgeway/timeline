defmodule Timeline.Chart do
  alias Timeline.{Main}

  def output(t) do
    # t
    # |> IO.inspect(label: "")
    [] ++ [
      Enum.reduce(t, [], fn {{_x,_y}, value}, output_list ->
        output_list ++ ["#{value}"]
      end)
    ]
    # TODO might be annoying to try to piecebypiece rewrite this when I get here next, instead maybe just restart it in the make sense way with enum rows, enum cols, like other times I've done ascii
  end

  def new(main) do
    history_to_current =
      main
      |> Main.history_to_current

    Enum.reduce(1..length(history_to_current), Map.new, fn x, map ->
      value = history_to_current |> Enum.at(x-1)
      map |> Map.put({x,1}, value)
    end)

    # draw y=1's
  end

  def at(t, key) do
    Map.get(t, key)
  end

  def max_x(t), do: map_size(t)
  def max_y(_t), do: 1
end
