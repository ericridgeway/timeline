defmodule TimelineTest.Chart do
  use ExUnit.Case

  alias Timeline.{Chart, Main}

  test "todo" do
    main =
      Main.new
      |> Main.add("cat")
      |> Main.add("dog")

    assert main |> Chart.output == ~w[1-1-cat 2-1-dog]
  end
end
