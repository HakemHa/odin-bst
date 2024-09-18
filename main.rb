require_relative "./bin_tree"

test = Tree.new(Array.new(15) { rand(1..100) })
p "Balanced? #{test.balanced?}"
test.pretty_print
p "In level: #{test.level_order}"
p "In order: #{test.inorder}"
p "In preorder: #{test.preorder}"
p "In postorder: #{test.postorder}"
p "Adding new elements..."
for n in Array.new(150) { rand(1..100) } do
  test.insert(n)
end
test.pretty_print
p "Balanced? #{test.balanced?}"
test.rebalance
p "Rebalanced? #{test.balanced?}"
test.pretty_print
p "In level: #{test.level_order}"
p "In order: #{test.inorder}"
p "In preorder: #{test.preorder}"
p "In postorder: #{test.postorder}"