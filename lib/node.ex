defmodule Timeline.Node do

  def new(value, id) do
    %{
      value: value,
      id: id,
    }
  end

  def value(t), do: t |> Map.get(:value)

  def match?(t, target_id), do: t.id == target_id
end
