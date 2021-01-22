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

  test "History to current" do
    empty_main = Main.new
    single_main = Main.new |> Main.add("boar")

    assert empty_main |> Main.history_to_current == []
    assert single_main |> Main.history_to_current == ~w[boar]
  end

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
      |> Main.add("bat")

    assert main |> Main.history_to_current == ~w[cat dog mouse bat]
  end

  test "up down" do
    empty_main = Main.new
    main_up =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")
      |> Main.add("mouse")
      |> Main.undo
      |> Main.add("cheese")
      |> Main.up

    assert empty_main |> Main.up |> Main.history_to_current == []

    assert main_up |> Main.history_to_current == ~w[cat dog mouse]
    assert main_up |> Main.up |> Main.history_to_current == ~w[cat dog mouse]

    main_down = main_up |> Main.down
    assert main_down |> Main.history_to_current == ~w[cat dog cheese]
  end

  test "Up with single add" do
    single_main = Main.new |> Main.add("boar")

    assert single_main |> Main.history_to_current == ~w[boar]
    assert single_main |> Main.up |> Main.history_to_current == ~w[boar]
  end

  test "any_ups?" do
    main =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")
      |> Main.undo
      |> Main.add("mouse")

    assert main |> Main.any_ups?
    refute main |> Main.add("cheese") |> Main.any_ups?
  end

  test "any_downs?" do
    refute Main.new |> Main.add("tree") |> Main.any_downs?
  end

  test "any_ups?/downs edgecase empty Main" do
    refute Main.new |> Main.any_ups?
  end

  # tmp internal
  test "1 'up' on list" do
    demo_list = ~w[a b c]

    assert Main.up_list(demo_list, "b") == "a"
    assert Main.up_list(demo_list, "a") == "a"
  end

  # tmp internal
  test "1 'down' on list" do
    demo_list = ~w[a b c]

    assert Main.down_list(demo_list, "a") == "b"
    assert Main.down_list(demo_list, "c") == "c"
  end

  # TODO defp siblings when del this
  # tmp internal
  test "siblings" do
    main =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")
      |> Main.add("mouse")
      |> Main.undo
      |> Main.add("cheese")

    assert Main.sibling_list(main, main.current_node_id) |> Enum.map(&Timeline.Node.value/1) ==
      ~w[mouse cheese]
  end


  # # tmp internal
  # test "sort children before giving back or checking first_child. Use sort_all_by_id" do
  # end

  # test "any undos?" (logic already exists under dif func name or maybe in undo clause, extract func and call that in the same spot in undo
  # test "any redos?" do
  # test anyUps, anyDowns?

  # # big test above, down, should end in ~w[cat dog cheese] or w/e
  # # DRY the big prob

#   # test "sort by creation order" do
end
