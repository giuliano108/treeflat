class LeafTransform
    # - match_rule is a mixed array of strings and regexps
    #   they are tested against the corresponding node in a path
    # - transform_function: if the path matched match_rule, call this
    # - indexes: after a transform is applied, which nodes in the path are indexes?
    attr_accessor :match_rule, :index_rule, :transform_function
    def initialize(match_rule,index_rule=[0],&transform_func)
        if !match_rule.is_a?(Array) || match_rule.find {|r| !(r.is_a?(String) || r.is_a?(Regexp))}
            raise(ArgumentError,"`match_rule' must be an Array of Strings or Regexps")
        end
        @match_rule         = match_rule
        if !index_rule.is_a?(Array) || index_rule.find {|i| !i.is_a?(Fixnum)}
            raise(ArgumentError,"`index_rule' must be an Array of Fixnums")
        end
        @index_rule         = index_rule
        @transform_function = transform_func
    end

    def transform(leaf)
        matches = @match_rule.each_with_index.all? do |rule,i|
            if rule.is_a? Regexp
                leaf.path[i].to_s =~ rule
            else
                leaf.path[i] == rule
            end
        end
        if matches
            @transform_function.call(leaf)
        end
    end
end  
  
  
  
