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

  def history_to_current(t) do
    new_list = [get_node(t, t.current_node_id)]

    new_list = add_parent_node_to_list(new_list, t)
    new_list = add_parent_node_to_list(new_list, t)
    new_list = add_parent_node_to_list(new_list, t)
    new_list = add_parent_node_to_list(new_list, t)
    new_list = add_parent_node_to_list(new_list, t)

    new_list = Enum.map(new_list, fn node -> node |> Node.value end)
  end

  defp add_parent_node_to_list(old_list, t) do
    hd_id = hd(old_list) |> Node.id
    parent = parent(t, hd_id)

    if parent == nil do
      old_list
    else
      [parent | old_list]
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

  def current_node_id(t), do: t.current_node_id

  # defp current_node(t), do: get_node(t, t.current_node_id)

#   def ascii_output(t) do
#     # if t.moves == ["1"] do
#     #   [
#     # else
#     #   []
#     # end
#     t.nodes
#   end
end
