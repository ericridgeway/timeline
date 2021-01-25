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

    loop(%{}, nil, 1, main)
  end

  defp loop(t, cur_check_node, y, main) do
    cur_check_id = cur_check_node |> Node.id

    if (main |> Main.size == 0) or (cur_check_node == nil and t != %{}) do
      t
    else
      first_child = Main.first_child(main, cur_check_id)
      first_child_id = first_child |> Square.id

      if first_child == nil or already_added?(t, first_child_id) do
        # tmp step b


      else
        first_children = main |> Main.first_children
        proposed_map_adds =
          Enum.reduce(first_children, %{}, fn proposed_node, proposed_map_adds ->
            proposed_id = proposed_node |> Node.id
            proposed_value = proposed_node |> Node.value

            x = Main.move_num(main, proposed_id)
            square = Square.new(proposed_id, proposed_value, :left)

            Map.put(proposed_map_adds, {x,y}, square)
          end)
        # TODO push-down if overlap test, right here redoes loop with y + 1
        # TODO loop cur-check = last on proposed_map_adds (use max_x?)
      end


    end
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


  defp already_added?(t, id) do
    already_added_ids =
      Enum.map(t, fn {pair, square} -> square |> Square.id end)
    id in already_added_ids
  end
end
