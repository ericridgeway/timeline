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
    # ~w[1-1-cat 2-1-dog]
  end
end
