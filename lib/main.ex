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
    Map.put(t, :nodes, nodes)
  end

  def value(_t, _id) do
    "cat"
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
