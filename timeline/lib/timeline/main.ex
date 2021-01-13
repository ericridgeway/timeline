defmodule Timeline.Main do

  def new() do
    []
  end

  def add(t, new) do
    [new | t]
  end

  def get(t), do: t |> Enum.reverse()
end
