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
    nodes = t.nodes ++ [Node.new(value, manual_id)]
    t
    |> Map.put(:nodes, nodes)
    |> Map.put(:current_node_id, manual_id)
  end

  def value(t, id) do
    t.nodes
    |> Enum.find(&Node.match?(&1, id))
    |> Node.value
  end

  def undo(t) do
    t |> Map.put(:current_node_id, t.current_node_id - 1)
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
