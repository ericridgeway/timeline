defmodule TimelineTest.Chart do
  use ExUnit.Case

  alias Timeline.{Chart, Main}

  test "Chart new" do
    chart =
      Main.new
      |> Main.add("cat")
      |> Main.add("mouse")
      |> Chart.new

    assert chart |> Chart.max_x == 2
    assert chart |> Chart.max_y == 1
    assert chart |> Chart.value_at({1,1}) == "cat"
    assert chart |> Chart.value_at({2,1}) == "mouse"
    assert chart |> Chart.value_at({100,100}) == nil
  end

  test "Just first row" do
    chart =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")
      |> Chart.new

    assert chart |> Chart.ascii_output == [
      ~w[-cat -dog],
    ]
  end

  test "Only down-from-ups" do
    chart =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")
      |> Main.undo
      |> Main.add("mouse")
      |> Main.undo
      |> Main.undo
      |> Main.add("monkey")
      |> Chart.new

    assert chart |> Chart.ascii_output == [
      ~w[-cat    -dog],
      ~w[|monkey |mouse],
    ]
  end

  test "Earlier sibling" do
    chart =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")
      |> Main.undo
      |> Main.undo
      |> Main.add("mouse")
      |> Chart.new

    # assert chart |> Chart.ascii_output == [
    #   ~w[-cat   -dog],
    #   ~w[|mouse .],
    # ]
  end
end
