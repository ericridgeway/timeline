defmodule TimelineTest.Main do
  use ExUnit.Case

  alias Timeline.{Main}

  test "add" do
    main =
      Main.new()
      |> Main.add("a1")
      |> Main.add("a2")
      |> Main.add("a3")

    assert main |> Main.history == ~w[a1 a2 a3]
    assert main |> Main.cur_value == "a3"
  end

  test "Undo" do
  end
end
