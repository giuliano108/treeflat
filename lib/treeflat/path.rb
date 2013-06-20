module TreeFlat
    class Path
        # @nodes Array of node names
        # @index_nodes is another Array containing pointers (offsets within @nodes) 
        # to special nodes whose names act as indexes (addressing sequences of similar objects/subtrees in the original tree).
        include DefaultInspect
        include Enumerable
        attr_accessor :nodes, :index_nodes
        def initialize(nodes, index_nodes=[])
            raise(ArgumentError,"`path' must be an Array") unless nodes.is_a? Array
            raise(ArgumentError,"`index_nodes' must be an Array") unless index_nodes.is_a? Array
            @nodes        = nodes
            @index_nodes  = index_nodes
        end

        def add_index(i)
            @index_nodes = @index_nodes + [i]
        end

        def name
            if @index_nodes.length > 0 && @index_nodes[-1] == (@nodes.length-1)
                @nodes[-2]
            else
                @nodes[-1]
            end
        end

        def index_values
            @nodes.values_at *@index_nodes
        end

        # Don't return index nodes
        def node_names
            @nodes.values_at *@nodes.each_index.reject {|i| @index_nodes.include? i}
        end

        # Path representation without index nodes
        def repr
            @nodes.values_at(*@nodes.each_index.reject {|i| @index_nodes.include? i}).join('/')
        end

        def each(&block)
            @nodes.each(&block)
        end
        def delete_at(i)
            @nodes.delete_at(i)
        end
        def [](i)
            @nodes[i]
        end
        def []=(i,value)
            @nodes[i] = value
        end
        def +(array)
            Path.new(@nodes + array,@index_nodes)
        end
        def length
            @nodes.length
        end
        def to_s
            %Q|"#{@nodes.join('/')}[#{@index_nodes.join ','}]"|
        end
    end
end
