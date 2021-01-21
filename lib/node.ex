defmodule Timeline.Node do

  def new(value, id, parent_id \\ nil) do
    %{
      value: value,
      id: id,
      parent_id: parent_id,
    }
  end

  def value(t), do: t |> Map.get(:value)

  def match?(t, target_id), do: t.id == target_id
end
