module UzAdmin
  class Meta  
    class Filter
      attr_accessor :field, :type
      def initialize hash
        @field = hash[:field]
        @type = hash[:type]      
      end
    end
  end
end