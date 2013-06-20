module TreeFlat
    class Leaf
        # Path is an Array of node names
        include DefaultInspect
        attr_accessor :path, :value
        def initialize(path, value=nil)
            raise(ArgumentError,"`path' must be an object of class Path") unless path.is_a? Path
            @path  = path
            @value = value
        end
        def to_s
            %Q|#{@path.to_s}="#{@value.to_s}"|
        end
    end
end
