defmodule TimelineTest.Main do
  use ExUnit.Case

  alias Timeline.{Main}

  setup do
    add3_main =
      Main.new()
      |> Main.add("a1")
      |> Main.add("a2")
      |> Main.add("a3")

    %{add3_main: add3_main}
  end

  test "add", %{add3_main: add3_main} do
    assert add3_main |> Main.history == ~w[a1 a2 a3]
    assert add3_main |> Main.cur_value == "a3"
  end

  test "Undo" do
  end
end
