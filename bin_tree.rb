class Node
  include Comparable
  def <=>(value)
    if value.instance_of?(Integer) then
      if @data < value then
        return -1
      elsif @data == value then
        return 0
      else
        return 1
      end
    else
      if @data < value.data then
        return -1
      elsif @data == value.data then
        return 0
      else
        return 1
      end
    end
    return nil
  end

  attr_accessor :left, :right
  attr_reader :data

  def initialize(data)
    if data.nil?  then
      raise "Incorrect data type"
    end
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  def initialize(arr)
    @root = self.build_tree(arr)
  end

  def build_tree(arr)
    arr = arr.uniq.sort
    m = arr.length/2
    root = Node.new(arr[m])
    if arr.length <= 3 then
      if m-1 >= 0 then
        root.left = Node.new(arr[m-1])
      end
      if m+1 < arr.length then
        root.right = Node.new(arr[m+1])
      end
    else
      root.left = self.build_tree(arr[0...m])
      root.right = self.build_tree(arr[m+1...arr.length])
    end
    return root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, at=@root)
    if find(value) then
      return
    end
    if at < value then
      if at.right.nil? then
        at.right = Node.new(value)
        return
      end
      self.insert(value, at.right)
    else
      if at.left.nil? then
        at.left = Node.new(value)
        return
      end
      self.insert(value, at.left)
    end
    return
  end

  def delete(value, at=@root)
    if !find(value) then
      return
    end
    if at < value
      if at.right == value then
        to_delete = at.right
        left = to_delete.left
        right = to_delete.right
        if !right.nil? then
          at.right = right
          right.left = left
        else
          at.right = left
        end
      else
        self.delete(value, at.right)
      end
    else
      if at.left == value then
        to_delete = at.left
        left = to_delete.left
        right = to_delete.right
        if !right.nil? then
          at.right = right
          right.left = left
        else
          at.right = left
        end
      else
        self.delete(value, at.left)
      end
    end
    return
  end

  def find(value, at=@root)
    if at == value then
      return at
    end
    if at < value then
      if at.right.nil? then
        return nil
      end
      self.find(value, at.right)
    else
      if at.left.nil? then
        return nil
      end
      self.find(value, at.left)
    end
  end

  def level_order(&block)
    if !block_given? then
      block = Proc.new { |x| x.data }
    end
    ans = []
    queue = Queue.new([@root])
    while queue.length > 0 do
      node = queue.pop
      node.left ? queue << node.left : nil
      node.right ? queue << node.right : nil
      ans << block.call(node)
    end
    return ans
  end

  def inorder
    if !block_given? then
      block = Proc.new { |x| x.data }
    end
    ans = []
    stack = [[@root, 0]]
    while stack.length > 0 do
      node, state = stack[stack.length-1]
      if state == 0 then
        stack[stack.length-1][1] = 1
        node.left ? stack << [node.left, 0] : nil
      else
        stack.pop
        ans << block.call(node)
        node.right ? stack << [node.right, 0] : nil
      end
    end
    return ans
  end

  def preorder
    if !block_given? then
      block = Proc.new { |x| x.data }
    end
    ans = []
    stack = [[@root, 0]]
    while stack.length > 0 do
      node, state = stack[stack.length-1]
      if state == 0 then
        stack[stack.length-1][1] = 1
        ans << block.call(node)
        node.left ? stack << [node.left, 0] : nil
      else
        stack.pop
        node.right ? stack << [node.right, 0] : nil
      end
    end
    return ans
  end

  def postorder
    if !block_given? then
      block = Proc.new { |x| x.data }
    end
    ans = []
    stack = [[@root, 0]]
    while stack.length > 0 do
      node, state = stack[stack.length-1]
      if state == 0 then
        stack[stack.length-1][1] = 1
        node.left ? stack << [node.left, 0] : nil
      elsif state == 1 then
        stack[stack.length-1][1] = 2
        node.right ? stack << [node.right, 0] : nil
      else
        stack.pop
        ans << block.call(node)
      end
    end
    return ans
  end

  def height(node)
    if node.nil? then
      return -1
    end
    return 1+[self.height(node.left), self.height(node.right)].max
  end

  def depth(node)
    ans = 0
    toNode = @root
    while node != toNode do
      ans += 1
      if toNode < node then
        toNode = toNode.right
      else
        toNode = toNode.left
      end
    end
    return ans
  end

  def balanced?(at=@root)
    left_height, left_balanced = 0, true
    if !at.left.nil? then
      left_height = self.height(at.left)
      left_balanced = self.balanced?(at.left)
    end
    right_height, right_balanced = 0, true
    if !at.right.nil? then
      right_height = self.height(at.right)
      right_balanced = self.balanced?(at.right)
    end
    if left_balanced && right_balanced && (right_height - left_height).abs <= 1 then
      return true
    else
      return false
    end
  end

  def rebalance
    to_reset = self.level_order.sort
    @root = self.build_tree(to_reset)
  end
end