module TreeFlat
    class Columns
        include Enumerable
        def initialize(leaves=nil)
            @columns           = []
            @indexes_seen      = {}
            @current_column_no = 0
            @columns_index     = {}
            from_leaves leaves unless leaves.nil?
        end

        def add_from_leaf(leaf)
            raise(ArgumentError,"`leaf' must be an object of class Leaf") unless leaf.is_a? Leaf
            repr = leaf.path.repr
            leaf.path.index_nodes.each do |i|
                @indexes_seen[i] ||= 0
                @indexes_seen[i] += 1
            end
            unless @columns.find {|c| c.repr == repr}
                # TODO: something clever for columns with the same name but different reprs
                @columns << Column.new(repr,leaf.path.name,@current_column_no)
                @current_column_no += 1
            end
        end

        def build_index
            @columns.each { |c| @columns_index[c.repr] = c }
        end

        def get_idx_from_path path
            @columns_index[path.repr].idx
        end

        def each(&block)
            @columns.each(&block)
        end

        def from_leaves leaves
            raise(ArgumentError,"`leaves' must be an object of class Leaves") unless leaves.is_a? Leaves
            leaves.each { |leaf| add_from_leaf leaf }
            build_index
            @columns
        end
    end
end
