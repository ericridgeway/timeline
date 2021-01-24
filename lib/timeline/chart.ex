defmodule Timeline.Chart do
  alias Timeline.{Main, Node}
  alias Timeline.Chart.Square

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
