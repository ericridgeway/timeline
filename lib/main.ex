defmodule Timeline.Main do
  alias Timeline.{Node}

  def new() do
    %{
      nodes: [],
      current_node_id: nil,
      auto_id: 1,
    }
  end

  # manual_id override for testing; expect errors if ID's repeated
  def add(t, value, manual_id \\ nil) do
    old_current_id = t.current_node_id
    new_current_id = manual_id || t.auto_id
    new_auto_id = t.auto_id + 1

    nodes = t.nodes ++ [Node.new(value, new_current_id, old_current_id)]

    t
    |> Map.put(:nodes, nodes)
    |> Map.put(:current_node_id, new_current_id)
    |> Map.put(:auto_id, new_auto_id)
  end

  def undo(t) do
    parent = parent(t, t.current_node_id)
    if parent == nil do
      t
    else
      parent_id = parent |> Node.id
      t |> Map.put(:current_node_id, parent_id)
    end
  end

  def redo(t) do
    children = children(t, t.current_node_id)

    if children == [] do
      t
    else
      first_child_id = children |> hd |> Node.id
      t |> Map.put(:current_node_id, first_child_id)
    end
  end

  def history_to_current(%{current_node_id: nil}), do: []
  def history_to_current(t) do
    t
    |> current_node
    |> List.wrap
    |> add_all_parent_nodes_to_list(t)
    |> Enum.map(&Node.value/1)
  end

  defp add_all_parent_nodes_to_list(old_list, t) do
    hd_id = hd(old_list) |> Node.id
    parent = parent(t, hd_id)

    if parent == nil do
      old_list
    else
      new_list = [parent | old_list]

      add_all_parent_nodes_to_list(new_list, t)
    end
  end

  # TODO might need (t, nil), do: nil -- or something as an extra def here, depending on if Find below errors or sends back nil
  def get_node(t, id) do
    t.nodes
    |> Enum.find(&Node.match?(&1, id))
  end

  def value(t, id) do
    get_node(t, id) |> Node.value
  end

  def parent(t, id) do
    parent = get_node(t, id)
    if parent == nil do
      nil
    else
      parent_id = parent |> Node.parent_id
      get_node(t, parent_id)
    end
  end

  def first_move?(t, id) do
    get_node(t, id) |> Node.parent_id == 1
  end

  def children(t, id) do
    Enum.filter(t.nodes, fn node ->
      node.parent_id == id
    end)
  end

  def first_child(t, id) do
    case children(t, id) do
      [] -> nil
      children -> children |> hd
    end
  end

  def sibling_list(t, id) do
    parent = parent(t, id)

    # NOTE another if parent == nil check
    if parent == nil do
      t.nodes
      |> Enum.filter(fn node -> Node.parent_id(node) == nil end)
    else
      children(t, parent |> Node.id)
    end
  end

  def any_ups?(t) do
    sibling_list = sibling_list(t, current_node_id(t))
    first_sibling = hd(sibling_list)

    current_node(t) != first_sibling
  end

  def up_list([], _), do: nil
  def up_list(sibling_list, current_value) do
    index = Enum.find_index(sibling_list, fn x -> x == current_value end)

    if index <= 0 do
      Enum.at(sibling_list, 0)
    else
      Enum.at(sibling_list, index - 1)
    end
  end

  def down_list(sibling_list, current_value) do
    sibling_list
    |> Enum.reverse
    |> up_list(current_value)
  end

  def up(t) do
    current_node_id = current_node_id(t)
    sibling_list = sibling_list(t, current_node_id)
    id_list = sibling_list |> Enum.map(&Node.id/1)

    up_1 = up_list(id_list, current_node_id)

    t |> Map.put(:current_node_id, up_1)
  end

  def current_node_id(t), do: t.current_node_id

  defp current_node(t), do: get_node(t, t.current_node_id)

#   def ascii_output(t) do
#     # if t.moves == ["1"] do
#     #   [
#     # else
#     #   []
#     # end
#     t.nodes
#   end
end
