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
        if Main.any_downs?(main, cur_check_id) do
          down_id = Main.down_id(main, cur_check_id)
          down_node = Main.get_node(main, down_id)
          loop(t, down_node, y, main)
        else
          parent_node = Main.parent(main, cur_check_id)
          parent_y = get_y(t, parent_node |> Node.id)
          loop(t, parent_node, parent_y, main)
        end


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
        if any_already_added?(t, proposed_map_adds) do
          loop(t, cur_check_node, y+1, main)
        else
          new_t = Map.merge(t, proposed_map_adds)
          last_child = first_children |> Enum.reverse |> hd
          loop(new_t, last_child, y, main)
        end
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

  defp get_y(t, id) do
    {{_x, y}, _square} =
      Enum.find(t, fn {pair, square} ->
        square |> Square.id == id
      end)
    y
  end

  defp any_already_added?(t, proposed_map_adds) do
    Enum.any?(proposed_map_adds, fn {pair, square} ->
      proposed_id = square |> Square.id
      already_added?(t, proposed_id)
    end)
  end

  defp already_added?(t, id) do
    already_added_ids =
      Enum.map(t, fn {pair, square} -> square |> Square.id end)
    id in already_added_ids
  end
end
