defmodule Timeline.Chart do
  alias Timeline.{Main}

  def output(main) do
    history_to_current =
      main
      # |> IO.inspect(label: "main")
      |> Main.history_to_current
      # |> IO.inspect(label: "history_to_current")

    for x <- 1..length(history_to_current) do
      animal = history_to_current |> Enum.at(x-1)
      "#{x}-1-#{animal}"
    end
  end

  def new(main) do
    history_to_current =
      main
      |> Main.history_to_current

    Enum.reduce(1..length(history_to_current), Map.new, fn x, map ->
      value = history_to_current |> Enum.at(x-1)
      map |> Map.put({x,1}, value)
    end)
  end

  def at(t, key) do
    Map.get(t, key)
  end

  def max_x(t), do: map_size(t)
  def max_y(_t), do: 1
end
