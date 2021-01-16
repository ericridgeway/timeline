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
    assert add3_main |> Main.turns == 3
  end

  # tmp note del, possible internal, I think fine tho?
  test "Turn order maintained" do
    main =
      Main.new()
      |> Main.add("c")
      |> Main.add("a")
      |> Main.add("b")

    assert main |> Main.history == ~w[c a b]
  end

  # tmp internal
  test "1 move parent correct" do
    expected_move = Timeline.Move.new(1, "cat", nil)
    main = Main.new |> Main.add("cat")
    history_mapset = main.history
    assert MapSet.member?(history_mapset, expected_move)
  end

  # tmp internal
  test "3 move parent correct" do
    main = Main.new |> Main.add("cat") |> Main.add("dog") |> Main.add("mouse")
           |> IO.inspect(label: "")
    expected_move1 = Timeline.Move.new(1, "cat", nil)
    expected_move2 = Timeline.Move.new(2, "dog", expected_move1)
    expected_move3 = Timeline.Move.new(3, "mouse", expected_move2)
    history_mapset = main.history

    for expected_move <- [expected_move1, expected_move2, expected_move3] do
      assert MapSet.member?(history_mapset, expected_move)
    end
  end

  # # oh most_recent_move and parent are the same thing
  # test "parent" do
  #   assert Main.new |> Main.parent == nil
  #   assert Main.new |> Main.parent == nil
  # end

  # # tmp internal or unneces func?
  # test "1 move, move knows parent", ~M{add3_main} do
  #   assert Main.new |> Main.add("hi") |> Main.history_with_parents == ~w[()hi]
  # end

  # # tmp internal or unneces func?
  # test "move knows parent", ~M{add3_main} do
  #   assert add3_main |> Main.history_with_parents == ~w[()a1 (1-a1)a2 (2-a2)a3]
  # end

  # NOTE Main.history might not be the final func...

  # test "Undo", %{add3_main: add3_main} do
  #   assert "a2" ==
  #     add3_main
  #     |> Main.undo
  #     |> Main.cur_value
  # end

  # test "Redo", %{add3_main: add3_main} do
  #   assert "a3" ==
  #     add3_main
  #     |> Main.undo
  #     |> Main.redo
  #     |> Main.cur_value
  # end

  # test "Undo edge cases", %{add3_main: add3_main} do
  #   main =
  #     add3_main
  #     |> Main.undo
  #     |> Main.undo
  #     |> Main.undo
  #     |> Main.add("cat")

  #   assert main |> Main.history == ~w[cat]
  #   assert Main.new |> Main.undo == Main.new
  # end

  # test "Redo edge cases", %{add3_main: add3_main} do
  #   main =
  #     add3_main
  #     |> Main.undo
  #     |> Main.redo
  #     |> Main.redo

  #   assert main == add3_main
  #   assert Main.new |> Main.redo == Main.new
  # end

  # test "any_undos?" do
  #   refute Main.new |> Main.any_undos?
  # end

  # test "any_redos?" do
  #   refute Main.new |> Main.any_redos?
  # end

  # # test "Undo then move creates branch", ~M{add3_main} do
  # #   main =
  # #     add3_main
  # #     |> Main.undo
  # #     |> Main.add("b3")
  # #   assert main |> Main.history == ~w[a1 a2 b3]

  # #   main =
  # #     main
  # #     |> Main.left
  # #   assert main |> Main.history == ~w[a1 a2 a3]

# # #     main =
# # #       main
# # #       |> Main.right
# # #     assert main |> Main.history == ~w[a1 a2 b3]
  # # end

  # # # tmp internal
  # # test "is_this_overwriting", ~M{add3_main} do
  # #   main =
  # #     add3_main
  # #     |> Main.undo
  # #     # |> Main.add("b3")

  # #   assert Main.is_this_overwriting?("b3")
  # #   refute Main.is_this_overwriting?("a3")
  # #   # NOTE oh, this is the same as any_redos?

  # #   # assert main |> Main.history == ~w[a1 a2 b3]
  # # end

  # # test "left edgecase and any_lefts?" do
end
