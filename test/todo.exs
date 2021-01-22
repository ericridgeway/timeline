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
# Above might need uid's and be a mapset of stuff that holds it's parent, but the function logic should be close



# minor--
# refactor some of the parent == nil if do else blocks
# .might rethink what happens when parent/children == nil. The possible Node.id on nil instead of a node is brittle
# test "Add undo redo without..." can be trimmed or dry'd with other tests prob


# draw mode- one of the steps for the x,y drawing mode will be "all first_child's" or all up's-to-leaf (and for current y and current x + that allFirstChilds>length, is something already there. Actually no, you'll need to loop for each of them and see if something already there. If you're clear, add them, if not, increase y by 1 and keep drawing


# main--
# I think we want ascii at same time
# Main.add uses [new | old] and Enum reverse at some point (for elixir effeciency)
# .actually nodes should prob just be a mapset
# ascii for Current move, add * or something
# .save current as a Node field, or keep Node uid's and save current as a Main field?
# node generates it's own uuid prob
# switch to parent/first-child(?) checks for undo-redo so I can stop using 1<->length checks on the id
# .then I can go back to: Node.new should default parent_id to nil prob, not 1
# .Main.first_move? check will need update accordingly too
# Node.new checks in test slightly ugly, esp manually knowing what prev id is
# switch id/auto_id/default to fix the root/1/0 case
# dry/clean/recursion history_to_current
# first_child and redo() have same or similar logic, can dry one into the other I think
# go through main and see which def's can be switched to defp without breaking
# history_to_current test using override ids
# .kill option in Main.add to override manual_id
# dedupe Main.up and .down
# .I might not even need .list_down if I do up/down right
