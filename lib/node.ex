defmodule Timeline.Node do

  # def new(value, id, parent_id \\ nil) do
  def new(value, id, parent_id \\ 1) do
    %{
      value: value,
      id: id,
      parent_id: parent_id,
    }
  end

  def match?(t, target_id), do: t.id == target_id

  def parent_id(t), do: t.parent_id
  def id(t), do: t.id
  def value(t), do: t.value
end
