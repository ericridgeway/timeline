defmodule Timeline.Node do

  def new(value, id) do
    %{
      value: value,
      id: id,
    }
  end
end
