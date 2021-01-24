defmodule Timeline.Node do

  def new(value, id, parent_id \\ nil) do
    %{
      value: value,
      id: id,
      parent_id: parent_id,
    }
  end

  def match?(t, target_id), do: t.id == target_id

  def id(nil), do: nil
  def id(t), do: t.id

  def parent_id(nil), do: nil
  def parent_id(t), do: t.parent_id

  def value(nil), do: nil
  def value(t), do: t.value
end
