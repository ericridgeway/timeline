defmodule Timeline.Chart do
  alias Timeline.{Main, Node}
  alias Timeline.Chart.Square
  alias AsciiOutput.Main, as: AsciiOutput

  def new(main) do
    t =
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

    last_pair = {max_x(t), 1}
    last_square = Map.get(t, last_pair)
    last_id = last_square |> Square.id

    if Main.any_downs?(main, last_id) do
      down_id = Main.down_id(main, last_id)
      down_value = Main.get_node(main, down_id) |> Node.value
      y = 2
      x = Main.move_num(main, down_id)
      square = Square.new(down_id, down_value, :up)

      Map.put(t, {x,y}, square)
    else
      t
    end

    # loop(%{}, nil, 1, main)
  end

  # defp loop(t, cur_check_node, y, main, force_draw \\ false) do
  #   IO.puts "*****starttt"; require InspectVars; InspectVars.inspect([t, cur_check_node, y])
  #   cur_check_id = cur_check_node |> Node.id

  #   if (main |> Main.size == 0) or (cur_check_node == nil and t != %{}) do
  #     IO.puts "finished, return t"
  #     t
  #   else
  #     first_child = Main.first_child(main, cur_check_id)
  #     first_child_id = first_child |> Square.id

  #     if not(force_draw) and (first_child == nil or already_added?(t, first_child_id)) do
  #       # tmp step b
  #       if Main.any_downs?(main, cur_check_id) do
  #         down_id = Main.down_id(main, cur_check_id)
  #         down_node = Main.get_node(main, down_id)
  #         IO.puts "any_downs? true, go down"
  #         loop(t, down_node, y+1, main, true)
  #       else
  #         parent_node = Main.parent(main, cur_check_id)
  #         parent_y = get_y(t, parent_node |> Node.id)
  #         IO.puts "go parent"
  #         loop(t, parent_node, parent_y, main)
  #       end


  #     else
  #       first_children = main |> Main.first_children(cur_check_id)
  #       proposed_map_adds =
  #         Enum.reduce(first_children, %{}, fn proposed_node, proposed_map_adds ->
  #           proposed_id = proposed_node |> Node.id
  #           proposed_value = proposed_node |> Node.value

  #           x = Main.move_num(main, proposed_id)
  #           square = Square.new(proposed_id, proposed_value, :left)

  #           Map.put(proposed_map_adds, {x,y}, square)
  #         end)
  #         |> IO.inspect(label: "proposed_map_adds")
  #       if any_already_added?(t, proposed_map_adds) do
  #         IO.puts "111111111already added?"
  #         loop(t, cur_check_node, y+1, main)
  #       else
  #         new_t = Map.merge(t, proposed_map_adds)
  #         last_child = first_children |> Enum.reverse |> hd
  #         IO.puts "addProposedAndRunWithLast"; require InspectVars; InspectVars.inspect([new_t, last_child])
  #         loop(new_t, last_child, y, main)
  #       end
  #     end


  #   end
  # end


  def ascii_output(t) do
    value_fn = fn square ->
      value = square |> Square.value
      source_direction = square |> Square.source_direction
      source_ascii =
        case source_direction do
          :up -> "|"
          _left -> "-"
        end
        "#{source_ascii}#{value}"
    end
    t |> AsciiOutput.ascii_output(value_fn)
  end

  def max_x(t), do: t |> AsciiOutput.max_x
  def max_y(t), do: t |> AsciiOutput.max_y

  def value_at(t, key) do
    Map.get(t, key) |> Square.value
  end

  # defp get_y(t, id) do
  #   pair_and_square =
  #     Enum.find(t, fn {pair, square} ->
  #       square |> Square.id == id
  #     end)

  #   if pair_and_square == nil do
  #     :idk
  #   else
  #     {{_x, y}, _square} = pair_and_square
  #     y
  #   end
  # end

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
