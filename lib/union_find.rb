# Union-Find (Disjoint-Set) Implementation
# Efficiently manages connected components for row grouping
class UnionFind
  def initialize(size)
    # Each node initially points to itself as parent
    @parent = (0...size).to_a
    # Track tree depth to optimize union operations
    @rank = Array.new(size, 0)
  end

  # Find root with path compression
  # Flattens structure for faster subsequent queries
  def find(x)
    while @parent[x] != x
      @parent[x] = @parent[@parent[x]]  # Path compression
      x = @parent[x]
    end
    x
  end

  # Merge two components using union by rank
  # Maintains balanced trees for optimal performance
  def union(x, y)
    x_root = find(x)
    y_root = find(y)
    return if x_root == y_root  # Already connected

    # Attach smaller tree to larger tree's root
    if @rank[x_root] < @rank[y_root]
      @parent[x_root] = y_root
    else
      @parent[y_root] = x_root
      @rank[x_root] += 1 if @rank[x_root] == @rank[y_root]
    end
  end

  # Generate unique group IDs for connected components
  def assign_group_ids
    group_mapping = {}
    person_ids = Array.new(@parent.size)

    # Map root nodes to sequential group IDs
    @parent.each_with_index do |_, i|
      root = find(i)
      group_mapping[root] ||= group_mapping.size + 1
    end

    # Create final ID mapping for all elements
    @parent.each_with_index do |_, i|
      person_ids[i] = group_mapping[find(i)]
    end

    person_ids
  end
end
