module UzAdmin
  class Meta  
    class Filter
      attr_accessor :field, :type, :options
      def initialize hash
        @field = hash[:field]
        @type = hash[:type] 
        @options = hash[:options]      
      end
    end
  end
end