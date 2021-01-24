defmodule Timeline.Chart do
  alias Timeline.{Main, Node}
  alias Timeline.Chart.Square
  alias AsciiOutput.Main, as: AsciiOutput

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

  def ascii_output(t) do
    value_fn = &(&1.value)
    t |> AsciiOutput.ascii_output(value_fn)
  end

  def max_x(t), do: t |> AsciiOutput.max_x
  def max_y(t), do: t |> AsciiOutput.max_y

  def value_at(t, key) do
    Map.get(t, key) |> Square.value
  end
end
