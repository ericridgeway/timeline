# Done+
# + dry test with setup
# add
# undo
# redo


# left
# right
# any undo/redo/left/right?
# reverse history list with elixir [h | main] style
# test any bad index errors from undo/redo/left/right when at end of list
# test add a3, undo, add a3 doesn't make new timeline?
# chang update_history and similar Main _history funcs to _timeline?
# extract Timeline module similar to History?
# extract Move (includes Turn and Value)


# base turns/turn on parent instead of tracking sep field
# add_history -> add_move_to_history

# note getting infinite nesting again
#   idea:
  # %{
  #   {1, "cat"} => nil,
  #   {2, "dog"} => {1, "cat"}
  #   {2, "mouse"} => {1, "cat"}
  #   {3, "whatever"} => {2, "mouse"}
  # }
  # parent({1, _}), do: nil
  # parent({turn, value}=turn_move_pair), do: Map.get(turn_move_pair)
  #
  # last_move: {3, "whatever"}
  #
  # history({3, "whatever"})
  # def history(turn_move_pair) do: [history(parent)| nil]
  # --- something like this. make simpler loop version before doing recursion if I can
  #
  # undo = last_move = parent(last_move)
  # redo = last_move =
  #   get children (1, cat)
  #     (ans: [{2, dog}, {2, mouse}] )
  #     |> hd()
  #
  # right_of(siblings, {2, dog}) = {2, mouse}
  # right_of(siblings, {2, mouse}) = {2, mouse} # return same if at edge
  # left_of ^
  #
  # sibling_row(2, dog) = [{2, dog}, {2, mouse}] # already wrote this above under "ans"
  # def sibling_row(pair), do parent(pair) |> get_children
  #
  # get_children is ez btw, it's just
  #  def get_children(parent_pair) Enum.filter(_child, parent -> parent == parent_pair
  #
  # left = last_move =
  #   sibling_row(last_move) |> left_of(last_move)

  # Um, I think that does it. Damnnnn if this works. I'm so smart. And pretty
