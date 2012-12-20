class Tree
  attr_accessor :children, :node_name

  def initialize(tree)
    @children = []
    if tree.size == 1
      @node_name = tree.keys[0]
      tree[@node_name].each do |child, grandchildren|
        @children << Tree.new({ child => grandchildren })
      end
    else
      @node_name = nil
    end
  end

  def visit_all(&block)
    visit &block  # pre-order
    children.each {|c| c.visit_all &block}  # recursive, pre-order dfs
  end

  def visit(&block)
    block.call self
  end

  def to_s
    @node_name
  end
end

# Note Hashes in Ruby < 1.9 are unlinked; Hashes in Ruby >= 1.9 are linked
tree = Tree.new({
  'root' => {
    'child_a' => {},
    'child_b' => {},
    'child_c' => {
      'child_d' => {
        'child_e' => {}
      }
    },
    'child_f' => {}
  }
})

puts "visit single node"
tree.visit {|node| puts node.node_name}

puts "visit tree"
tree.visit_all {|node| puts node.node_name}
