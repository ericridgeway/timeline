defmodule Timeline.Chart do
  alias Timeline.{Main, Node}
  alias Timeline.Chart.Square

  def ascii_output(t) do
    # t
    # |> IO.inspect(label: "")
    [] ++ [
      Enum.reduce(t, [], fn {{_x,_y}, value}, output_list ->
        output_list ++ ["#{value}"]
      end)
    ]
    # TODO might be annoying to try to piecebypiece rewrite this when I get here next, instead maybe just restart it in the make sense way with enum rows, enum cols, like other times I've done ascii
    # Enum.reduce(t, [], fn {pair, square}, row_list ->
    # # TODO next here, just pass on to about-to-be-made AsciiOutput lib
    # end)
  end

  def new(main) do
    main
    |> Main.first_children
    |> Enum.reduce(Map.new, fn node, map ->
      id = node |> Node.id
      value = node |> Node.value
      x = Main.move_num(main, id)
      y = 1
      square = Square.new(id, value, :left)

      Map.put(map, {x,y}, square)
    end)
  end

  def value_at(t, key) do
    Map.get(t, key) |> Square.value
  end

  def max_x(t) do
    t
    |> Enum.map(fn {{x,_y}, _square} -> x end)
    |> Enum.max
  end
  def max_y(t) do
    t
    |> Enum.map(fn {{_x,y}, _square} -> y end)
    |> Enum.max
  end
end
