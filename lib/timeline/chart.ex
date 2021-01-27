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

    draw_remaining_rows(t, main)
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
    Enum.reduce(1..100, t, fn cur_x, new_t ->
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
                new_t |> bump_ys(cur_y)
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


  defp occupied?(t, pair) do
    Map.has_key?(t, pair) and not placeholder?(t, pair)
  end

  defp add_placeholder_square_if_empty(t, pair) do
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

  defp bump_ys(t, this_y_or_lower) do
    Enum.reduce(t, Map.new, fn {{x,y}=pair, square}, new_t ->
      if y >= this_y_or_lower and not placeholder?(t, pair) do
        new_t
        |> Map.put({x, y+1}, square)
        |> add_placeholder_square_if_empty(pair)
      else
        Map.put(new_t, pair, square)
      end
    end)
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
end
