defmodule TimelineTest.Main do
  use ExUnit.Case
  import ShorterMaps

  alias Timeline.{Main}

  setup do
    add3_main =
      Main.new()
      |> Main.add("a1")
      |> Main.add("a2")
      |> Main.add("a3")

    ~M{add3_main}
  end

  test "add", ~M{add3_main} do
    assert add3_main |> Main.history == ~w[a1 a2 a3]
    assert add3_main |> Main.cur_value == "a3"
  end

  test "Undo", %{add3_main: add3_main} do
    assert "a2" ==
      add3_main
      |> Main.undo
      |> Main.cur_value
  end

  test "Redo", %{add3_main: add3_main} do
    assert "a3" ==
      add3_main
      |> Main.undo
      |> Main.redo
      |> Main.cur_value
  end

  # NOTE this will get changed to branching next
  test "First version of undo->add", %{add3_main: add3_main} do
    main =
      add3_main
      |> Main.undo
      |> Main.add("b3")

    assert main |> Main.history == ~w[a1 a2 b3]
    assert main |> Main.cur_value == "b3"
  end

  test "Undo edge cases", %{add3_main: add3_main} do
    assert Main.new |> Main.undo == Main.new

    main =
      add3_main
      |> Main.undo
      |> Main.undo
      |> Main.undo
      |> Main.add("cat")

    assert main |> Main.history == ~w[cat]
  end
end
