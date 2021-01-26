defmodule Timeline.Chart do
  alias Timeline.{Main, Node}
  alias Timeline.Chart.Square
  alias AsciiOutput.Main, as: AsciiOutput

  def new(main) do
    # draw_first_row
    t =
      main
      |> Main.first_children
      |> Enum.reduce(Map.new, fn node, map ->
        id = node |> Node.id
        add_square(map, main, 1, id, :left)
      end)

    t = draw_row(t, main, 2)
    t = draw_row(t, main, 3)
    t = draw_row(t, main, 4)
    t = draw_row(t, main, 5)




    # last_pair = {max_x(t), 1}
    # last_square = Map.get(t, last_pair)
    # last_id = last_square |> Square.id

    # if Main.any_downs?(main, last_id) do
    #   down_id = Main.down_id(main, last_id)
    #   add_square(t, main, 2, down_id, :up)
    # else
    #   t
    # end


    # loop(%{}, nil, 1, main)
  end


  defp draw_row(t, main, cur_y) do
    Enum.reduce(1..100, t, fn cur_x, new_t ->
      cur_pair = {cur_x, cur_y}

      # check_left
      new_t =
        if cur_x-1 == 0 do
          new_t
        else
          left_pair = {cur_x-1, cur_y}

          # left filled?
          if new_t |> Map.has_key?(left_pair) do
            # left_has_atleast_1_child?
            left_id = Map.get(new_t, left_pair) |> Square.id
            if Main.any_children?(main, left_id) do
              # NOTE SLIGHTLY diff from below. First_child returns node inst of id like below. Maybe make a right_id func to get them mostly the same for DRYing
              right_id = Main.first_child(main, left_id) |> Node.id

              add_square(new_t, main, cur_y, right_id, :left)
            else
              new_t
            end

          else
            new_t
          end

        end


        # check_up
      up_pair = {cur_x, cur_y-1}
        # up filled?
      new_t =
        if new_t |> Map.has_key?(up_pair) do
            # up_has_down?
          up_id = Map.get(new_t, up_pair) |> Square.id
          if Main.any_downs?(main, up_id) do
            down_id = Main.down_id(main, up_id)

            # bump_all_at_past_this_y_down_1 if overlap
            new_t =
              if Map.has_key?(new_t, cur_pair) do
                bump_ys(new_t, cur_y)
              else
                new_t
              end

            add_square(new_t, main, cur_y, down_id, :up)
          else
            new_t
          end

        else
          new_t
        end

    end)
  end

  defp add_square(t, main, y, id, source_direction) do
    value = Main.get_node(main, id) |> Node.value
    x = Main.move_num(main, id)
    square = Square.new(id, value, source_direction)

    Map.put(t, {x,y}, square)
  end

  defp bump_ys(t, this_y_or_lower) do
    Enum.reduce(t, Map.new, fn {{x,y}=pair, square}, new_t ->
      if y >= this_y_or_lower do
        Map.put(new_t, {x, y+1}, square)
      else
        Map.put(new_t, pair, square)
      end
    end)
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
      Enum.map(t, fn {_pair, square} -> square |> Square.id end)
    id in already_added_ids
  end
end
