module TreeFlat::DefaultInspect
    def inspect
        vars = self.instance_variables.
            map{|v| "#{v}=#{instance_variable_get(v).inspect}"}.join(",")
        "<#{self.class}: #{vars}>"
    end
end
