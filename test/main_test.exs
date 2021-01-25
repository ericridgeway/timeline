defmodule TimelineTest.Main do
  use ExUnit.Case
  # import ShorterMaps

  alias Timeline.{Main}

  test "store value, lookup value with id" do
    main =
      Main.new
      |> Main.add("cat", 1)

    assert main |> Main.value(1) == "cat"
  end

  test "Undo" do
    main =
      Main.new
      |> Main.add("cat", 1)
      |> Main.add("dog", 2)
      |> Main.undo

    assert main |> Main.current_node_id == 1
    assert main |> Main.undo |> Main.current_node_id == nil
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

  # NOTE del this test?
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

  test "up/down" do
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

  test "any_undos? redos?" do
    refute Main.new |> Main.any_undos?
    refute Main.new |> Main.any_redos?
  end

  test "SHOULD be able to undo to []" do
    empty_main = Main.new
    move_1_main = empty_main |> Main.add("puppy")
    undo_to_empty_main = move_1_main |> Main.undo

    assert Main.any_undos?(move_1_main)
    assert undo_to_empty_main |> Main.history_to_current == ~w[]
  end

  test "first_children" do
    main =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")
      |> Main.add("mouse")
      |> Main.undo
      |> Main.add("cheese")

    first_children_nodes = main |> Main.first_children
    first_children_values = first_children_nodes |> Main.just_values
    assert first_children_values == ~w[cat dog mouse]
  end

  test "first_children from some id" do
    main =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")
      |> Main.add("mouse")

    cat_id = 1
    first_children_nodes = main |> Main.first_children(cat_id)
    first_children_values = first_children_nodes |> Main.just_values
    assert first_children_values == ~w[dog mouse]
  end

  test "Move num from some id" do
    main =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")
      |> Main.undo
      |> Main.add("mouse")

    cat_id = 1
    mouse_id = 3

    assert main |> Main.move_num(cat_id) == 1
    assert main |> Main.move_num(mouse_id) == 2
  end

  test "size" do
    assert Main.new |> Main.size == 0
    assert Main.new |> Main.add("moo") |> Main.size == 1
  end
end
