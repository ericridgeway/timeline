defmodule Timeline.History do

  def new(), do: []

  def add(t, new), do: t ++ [new]

  def size(t), do: length(t)

  def at(t, num), do: t |> Enum.at(num)

  def trim(t, num), do: t |> Enum.take(num)
end
