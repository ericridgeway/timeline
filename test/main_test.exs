defmodule TimelineTest.Main do
  use ExUnit.Case
  import ShorterMaps

  alias Timeline.{Main, Node}

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

  test "Undo moves Current back" do
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

  test "History to current" do
    main =
      Main.new
      |> Main.add("cat", 1)
      |> Main.add("dog", 2)
      |> Main.add("mouse", 3)
      |> Main.undo
      |> Main.add("cheese", 4)

    expected = [Node.new("cat", 1), Node.new("dog", 2, 1), Node.new("cheese", 4, 2)]

    assert main |> Main.history_to_current == expected
  end

  # tmp internal
  test "get_node" do
    main =
      Main.new
      |> Main.add("cat", 1)
      |> Main.add("dog", 2)

    assert main |> Main.get_node(2) == Node.new("dog", 2, 1)
  end

  # tmp internal
  test "parent" do
    main =
      Main.new
      |> Main.add("cat", 1)
      |> Main.add("dog", 2)

    assert main |> Main.parent(2) == Node.new("cat", 1)
  end

  # tmp internal
  test "first move" do
    main =
      Main.new
      |> Main.add("cat", 1)
      |> Main.undo
      |> Main.add("dog", 2)

    assert main |> Main.first_move?(2) == true
  end

  # tmp internal
  test "children" do
    main =
      Main.new
      |> Main.add("cat", 1)
      |> Main.add("dog", 2)
      |> Main.add("mouse", 3)
      |> Main.undo
      |> Main.add("cheese", 4)

    assert main |> Main.children(2) == [Node.new("mouse", 3, 2), Node.new("cheese", 4, 2)]
    # assert main |> Main.first_child(1) == Node.new("dog", 2, 1)
  end

  # test "Add undo redo without overriding id's" do
  #   main =
  #     Main.new
  #     |> Main.undo
  #     |> Main.add("cat", 1)
  #     |> Main.add("dog", 2)
  #     |> Main.add("mouse", 3)
  #     |> Main.undo
  #     |> Main.add("cheese", 4)
  #     |> Main.undo
  #     |> Main.redo
  #     |> Main.redo
  #     |> Main.redo
  #     |> Main.redo
  #     |> IO.inspect(label: "")

# #     assert main |> Main.first_child(1) == Node.new("dog", 2, 1)
# #     assert main |> Main.first_child(4) == nil
  # end

#   # test "sort by creation order" do
end
