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
      |> Main.add("cheese")
      |> Main.undo
      |> Main.undo
      |> Main.add("monkey")
      |> Chart.new

    assert chart |> Chart.ascii_output == [
      ~w[-cat    -dog],
      ~w[|monkey |mouse],
      ~w[.       |cheese],
    ]
  end

  test "From-left" do
    chart =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")
      |> Main.undo
      |> Main.undo
      |> Main.add("monkey")
      |> Main.add("cheese")
      |> Main.add("bird")
      |> Chart.new

    assert chart |> Chart.ascii_output == [
      ~w[-cat    -dog    .],
      ~w[|monkey -cheese -bird],
    ]
  end

  test "from-up AND from-left, causing overlap, needs to bump down" do
    chart =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")
      |> Main.undo
      |> Main.add("cheese")
      |> Main.undo
      |> Main.undo
      |> Main.add("monkey")
      |> Main.add("mouse")
      |> Chart.new

    assert chart |> Chart.ascii_output == [
      ~w[-cat    -dog],
      ~w[|       |cheese],
      ~w[|monkey -mouse],
    ]
  end

  test "Big complicated one just to be sure" do
    chart =
      Main.new
      |> Main.add("a")
      |> Main.add("b")
      |> Main.undo
      |> Main.add("c")
      |> Main.add("d")
      |> Main.undo
      |> Main.add("e")
      |> Main.add("f")
      |> Main.undo
      |> Main.undo
      |> Main.undo
      |> Main.add("g")
      |> Main.add("h")
      |> Main.undo
      |> Main.undo
      |> Main.undo
      |> Main.add("i")
      |> Main.undo
      |> Main.add("j")
      |> Main.add("k")
      |> Main.add("l")
      |> Main.add("m")
      |> Chart.new

    assert chart |> Chart.ascii_output == [
      ~w[-a -b .   .],
      ~w[|i |c -d  .],
      ~w[|  |  |e -f],
      ~w[|  |g -h  .],
      ~w[|j -k -l -m],
    ]
  end

  test "Only leave up-extending placeholders if actually pushing down a from-up move" do
    chart =
      Main.new
      |> Main.add("a")
      |> Main.add("b")
      |> Main.add("c")
      |> Main.undo
      |> Main.add("d")
      |> Main.undo
      |> Main.undo
      |> Main.undo
      |> Main.add("e")
      |> Main.add("f")
      |> Main.add("g")
      |> Chart.new

    assert chart |> Chart.ascii_output == [
      ~w[-a -b -c],
      ~w[|  .  |d],
      ~w[|e -f -g],
    ]
  end

  test "TODO" do
    chart =
      Main.new
      |> Main.add("a")
      |> Main.add("b")
      |> Main.add("c")
      |> Main.undo
      |> Main.add("d")
      |> Main.undo
      |> Main.undo
      |> Main.add("e")
      |> Main.add("f")
      |> Main.undo
      |> Main.undo
      |> Main.undo
      |> Main.add("g")
      |> Chart.new

    assert chart |> Chart.ascii_output == [
      ~w[-a -b -c],
      ~w[|g |  |d],
      ~w[.  |e -f],
    ]
  end

  test "no error if empty timeline" do
    assert Main.new |> Chart.new == %{}
    assert Main.new |> Chart.new |> Chart.max_x == 0
  end

  test "infinite loop???" do
    chart =
      Main.new
      |> Main.add("a")
      |> Main.undo
      |> Main.add("b")
      |> IO.inspect(label: "before undo")
      |> Main.undo
      |> IO.inspect(label: "after undo")
      |> Chart.new
      |> IO.inspect(label: "chart")

  end
end
