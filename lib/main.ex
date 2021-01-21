defmodule Timeline.Main do
  alias Timeline.{Node}

  def new() do
    %{
      nodes: [],
      current_node_id: 1,
    }
  end

  # manual_id override for testing; expect errors if ID's repeated
  def add(t, value, manual_id \\ nil) do
    # nodes = t.nodes ++ [Node.new(value, manual_id, t.current_node_id)]
    nodes = t.nodes ++ [Node.new(value, manual_id)]
    t
    |> Map.put(:nodes, nodes)
    |> Map.put(:current_node_id, manual_id)
  end

  def undo(%{current_node_id: 1}=t), do: t
  def undo(t) do
    t |> Map.put(:current_node_id, t.current_node_id - 1)
  end

  # def redo(%{current_node_id: }=t) when length(asd) == 1, do: t
  def redo(t) do
    if t.current_node_id == length(t.nodes) do
      t
    else
      t |> Map.put(:current_node_id, t.current_node_id + 1)
    end
  end

  def history_to_current(t) do
    t.nodes
    |> Enum.filter(fn node -> node.id <= t.current_node_id end)
  end

  def get_node(t, id) do
    t.nodes
    |> Enum.find(&Node.match?(&1, id))
  end

  def value(t, id) do
    get_node(t, id) |> Node.value
  end

  def current(t), do: t.current_node_id

#   def ascii_output(t) do
#     # if t.moves == ["1"] do
#     #   [
#     # else
#     #   []
#     # end
#     t.nodes
#   end
end
