defmodule TimelineTest.Chart do
  use ExUnit.Case

  alias Timeline.{Chart, Main}

  test "Chart output" do
    chart =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")
      |> Chart.new

    assert chart |> Chart.output == [
      ~w[cat dog],
    ]
  end

  test "Chart new" do
    chart =
      Main.new
      |> Main.add("cat")
      |> Main.add("mouse")
      |> Chart.new

    assert chart |> Chart.max_x == 2
    assert chart |> Chart.max_y == 1
    assert chart |> Chart.at({1,1}) == "cat"
    assert chart |> Chart.at({2,1}) == "mouse"
    assert chart |> Chart.at({100,100}) == nil
  end

  test "new y" do
    chart =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")
      |> Main.undo
      |> Main.add("mouse")
      |> Chart.new

#     assert chart |> Chart.output == [
#       ~w[cat dog],
#       ~w[.   mouse],
#     ]
  end

  # tmp internal
  test "xy map made correct" do
    chart =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")
      |> Main.undo
      |> Main.add("mouse")
      |> Chart.new

    # assert chart |> Chart.at({2,2}) == "mouse"
    # assert chart |> Chart.max_y == 2
  end
end
