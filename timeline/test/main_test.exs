defmodule TimelineTest.Main do
  use ExUnit.Case

  alias Timeline.{Main}

  test "add" do
    main =
      Main.new()
      |> Main.add("a1")
      |> Main.add("a2")
      |> Main.add("a3")

    assert main |> Main.get == ~w[a1 a2 a3]
  end
end
