defmodule Timeline.Chart.Square do

  def new(id, value, source_direction) do
    %{
      id: id,
      value: value,
      source_direction: source_direction,
    }
  end

  def id(t), do: Map.get(t||%{}, :id)
  def value(t), do: Map.get(t||%{}, :value)
  def source_direction(t), do: Map.get(t||%{}, :source_direction)
end

# NOTE don't technically need id AND value. COULD use id to lookup value in main with get_node(main, id)
# "double storing" the value like this:
#   -makes testing a little easier, just pass around Chart instead of chart and main
#   -saves a bunch of bredth/depth/whatever tree lookups. Almost certainly doesn't help much, but oh well
#   -Con, as noted, is the double storing. Try not to use Square.value for anything other than testing, and to get it from Main.get_node usually

