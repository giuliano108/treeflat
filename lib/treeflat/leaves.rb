module TreeFlat
    class Leaves
        include Enumerable
        def initialize(tree = nil)
            from_tree tree unless tree.nil?
        end

        # Flatten a tree (array of nested hashes/arrays) into an array of leaves
        def flatten(data, path = Path.new([]))
            case data
            when Array
                data.each_with_index.map do |d,i|
                    pathi = path + [i]
                    pathi.add_index path.length
                    flatten(d, pathi)
                end
            when Hash
                data.map {|k,v| flatten(v, path + [k.to_s])}
            else 
                leaf = Leaf.new(path,data)
                @leaves << leaf
            end
            @leaves
        end

        def from_tree(tree)
            @leaves = []
            flatten(tree)
        end

        def transform(*transforms)
            [*transforms].each do |x|
                raise(ArgumentError,"tranforms must be objects of class LeafTransform") unless x.is_a? LeafTransform
            end
            @leaves.each do |leaf|
                [*transforms].each do |t|
                    t.transform leaf
                end
            end
        end

        def each(&block)
            @leaves.each(&block)
        end
        def [](i)
            @leaves[i]
        end
        def []=(i,value)
            @leaves[i] = value
        end
    end
end
