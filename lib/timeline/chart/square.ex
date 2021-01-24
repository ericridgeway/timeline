defmodule Timeline.Chart.Square do

  def new(id, source_direction) do
    %{
      id: id,
      source_direction: source_direction,
    }
  end

  def id(t), do: Map.get(t||%{}, :id)
  def source_direction(t), do: Map.get(t||%{}, :source_direction)
end
