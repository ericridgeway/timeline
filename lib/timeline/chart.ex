defmodule Timeline.Chart do
  alias Timeline.{Main, Node}
  alias Timeline.Chart.Square
  alias AsciiOutput.Main, as: AsciiOutput

  def new(main) do
    if main.nodes == [] do
      %{}
    else
      draw_first_row(main)
      |> draw_remaining_rows(main)
    end
  end

  def max_x(t) when map_size(t) == 0, do: 0
  def max_x(t), do: t |> AsciiOutput.max_x

  def max_y(t) when map_size(t) == 0, do: 0
  def max_y(t), do: t |> AsciiOutput.max_y

  def ascii_output(t), do: t |> AsciiOutput.ascii_output(&get_ascii_for_square/1)

  def value_at(t, key) do
    Map.get(t, key) |> Square.value
  end


  defp draw_remaining_rows(t, main, cur_y \\ 2) do
    t = draw_row(t, main, cur_y)

    if occupied_size(t) == Main.size(main) do
      t
    else
      draw_remaining_rows(t, main, cur_y + 1)
    end
  end

  defp draw_row(t, main, cur_y) do
    max_possible_x = Main.longest_num_moves(main)
    Enum.reduce(1..max_possible_x, t, fn cur_x, new_t ->
      cur_pair = {cur_x, cur_y}

      # check_left
      new_t =
        if cur_x-1 == 0 do
          new_t
        else
          left_pair = {cur_x-1, cur_y}

          # left filled?
          if new_t |> occupied?(left_pair) do
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
        if new_t |> occupied?(up_pair) do
            # up_has_down?
          up_id = Map.get(new_t, up_pair) |> Square.id
          if Main.any_downs?(main, up_id) do
            down_id = Main.down_id(main, up_id)

            # bump_all_at_past_this_y_down_1 if overlap
            new_t =
              if occupied?(new_t, cur_pair) do
                cur_id = Map.get(new_t, cur_pair) |> Square.id
                new_t |> bump_ys(cur_y, parent_and_self_ids(main, cur_id))
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

  defp draw_first_row(main) do
    main
    |> Main.first_children
    |> Enum.reduce(Map.new, fn node, map ->
      id = node |> Node.id
      add_square(map, main, 1, id, :left)
    end)
  end

  defp occupied?(t, pair) do
    Map.has_key?(t, pair) and not placeholder?(t, pair)
  end

  defp add_placeholder_square_if_empty_and_used_to_be_up(t, _, false), do: t
  defp add_placeholder_square_if_empty_and_used_to_be_up(t, pair, true) do
    if not occupied?(t, pair) do
      square = Square.new_placeholder
      Map.put(t, pair, square)
    else
      t
    end
  end

  defp add_square(t, main, y, id, source_direction) do
    value = Main.get_node(main, id) |> Node.value
    x = Main.move_num(main, id)
    square = Square.new(id, value, source_direction)

    Map.put(t, {x,y}, square)
  end

  # all lower ys AND (all same ys IF they're also on parent id whitelist)
  defp bump_ys(t, cur_y, id_list) do
    Enum.reduce(t, Map.new, fn {{x,y}=pair, square}, new_t ->
      square_id = square |> Square.id

      placeholder? = placeholder?(t, pair)
      past_cur_y? = y > cur_y

      same_y? = y == cur_y
      in_cur_branch? = square_id in id_list
      same_y_and_in_cur_branch? = same_y? and in_cur_branch?

      if not placeholder? and (past_cur_y? or same_y_and_in_cur_branch?) do
        pointed_up = square |> Square.source_direction == :up

        new_t
        |> Map.put({x, y+1}, square)
        |> add_placeholder_square_if_empty_and_used_to_be_up(pair, pointed_up)
      else
        Map.put(new_t, pair, square)
      end
    end)
  end

  defp parent_and_self_ids(main, id) do
      main
      |> Main.parents(id)
      |> Enum.map(fn node -> node |> Node.id end)
  end

  defp placeholder?(t, pair) do
    square = Map.get(t, pair)
    square |> Square.placeholder?
  end

  defp occupied_size(t) do
    t
    |> Enum.reject(fn {_pair, square} -> square |> Square.placeholder? end)
    |> length
  end

  def get_ascii_for_square(square) do
    source_ascii =
      case Square.source_direction(square) do
        :up -> "|"
        _left -> "-"
      end
    value = square |> Square.value

    "#{source_ascii}#{value}"
  end
end
