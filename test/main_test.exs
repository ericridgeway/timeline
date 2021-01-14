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

  test "Undo edge cases", %{add3_main: add3_main} do
    main =
      add3_main
      |> Main.undo
      |> Main.undo
      |> Main.undo
      |> Main.add("cat")

    assert main |> Main.history == ~w[cat]
    assert Main.new |> Main.undo == Main.new
  end

  test "Redo edge cases", %{add3_main: add3_main} do
    main =
      add3_main
      |> Main.undo
      |> Main.redo
      |> Main.redo

    assert main == add3_main
    assert Main.new |> Main.redo == Main.new
  end

  test "any_undos?" do
    refute Main.new |> Main.any_undos?
  end

  test "any_redos?" do
    refute Main.new |> Main.any_redos?
  end

  # test "Undo then move creates branch", ~M{add3_main} do
  #   main =
  #     add3_main
  #     |> Main.undo
  #     |> Main.add("b3")
  #   assert main |> Main.history == ~w[a1 a2 b3]

  #   main =
  #     main
  #     |> Main.left
  #   assert main |> Main.history == ~w[a1 a2 a3]

# #     main =
# #       main
# #       |> Main.right
# #     assert main |> Main.history == ~w[a1 a2 b3]
  # end

  # # tmp internal
  # test "is_this_overwriting", ~M{add3_main} do
  #   main =
  #     add3_main
  #     |> Main.undo
  #     # |> Main.add("b3")

  #   assert Main.is_this_overwriting?("b3")
  #   refute Main.is_this_overwriting?("a3")
  #   # NOTE oh, this is the same as any_redos?

  #   # assert main |> Main.history == ~w[a1 a2 b3]
  # end

  # test "left edgecase and any_lefts?" do
end
