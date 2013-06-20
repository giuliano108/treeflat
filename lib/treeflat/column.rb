module TreeFlat
    class Column
        attr_accessor :repr, :name, :idx
        def initialize(repr,name,idx)
            @repr    = repr
            @name    = name
            @idx     = idx
        end
    end
end
