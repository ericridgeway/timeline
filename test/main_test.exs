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

  test "store value, lookup value with id" do
    main =
      Main.new
      |> Main.add("cat", 1)

    assert main |> Main.value(1) == "cat"
  end

  test "Track current move" do
    move_1_main = Main.new |> Main.add("cat", 1)
    move_2_main = move_1_main |> Main.add("dog", 2)

    assert move_1_main |> Main.current_node_id == 1
    assert move_2_main |> Main.current_node_id == 2
  end

  test "Undo" do
    main =
      Main.new
      |> Main.add("cat", 1)
      |> Main.add("dog", 2)
      |> Main.undo

    assert main |> Main.current_node_id == 1
    assert main |> Main.undo |> Main.current_node_id == 1
  end

  test "Redo" do
    main =
      Main.new
      |> Main.add("cat", 1)
      |> Main.add("dog", 2)
      |> Main.undo
      |> Main.redo

    assert main |> Main.current_node_id == 2
    assert main |> Main.redo |> Main.current_node_id == 2
  end

  # TODO prob delete this after doing below test
  # test "History to current" do
  #   main =
  #     Main.new
  #     |> Main.add("cat", 1)
  #     |> Main.add("dog", 2)
  #     |> Main.add("mouse", 3)
  #     |> Main.undo
  #     |> Main.add("cheese", 4)

  #   expected = [Node.new("cat", 1), Node.new("dog", 2, 1), Node.new("cheese", 4, 2)]

  #   assert main |> Main.history_to_current == expected
  #   # main |> Main.history_to_current
  #   # |> IO.inspect(label: "")
  # end

  test "Add undo redo without overriding id's" do
    main =
      Main.new
      |> Main.undo
      |> Main.add("cat")
      |> Main.add("dog")
      |> Main.add("mouse")
      |> Main.undo
      |> Main.add("cheese")
      |> Main.undo
      |> Main.redo
      |> Main.redo
      |> Main.redo
      |> Main.redo

    assert main |> Main.history_to_current == ~w[cat dog mouse]
  end

  # tmp del after recursion
  test "history_to_current with 4 steps instead of 3 (for recursion)" do
    main =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")
      |> Main.add("mouse")
      |> Main.undo
      |> Main.add("cheese")
      |> Main.undo
      |> Main.redo
      |> Main.add("bat")

    assert main |> Main.history_to_current == ~w[cat dog mouse bat]
  end

  # test "down" do
  # # big test above, down, should end in ~w[cat dog cheese]
  # # DRY the big prob

#   # test "sort by creation order" do
end
