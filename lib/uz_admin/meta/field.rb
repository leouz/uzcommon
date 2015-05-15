module UzAdmin
  class Meta      
    class Field
      attr_accessor :name, :type, :options
      attr_accessor :title, :hidden
      def initialize hash
        @name = hash[:name]
        @type = hash[:type]        
        @options = {}

        @title = hash[:name].to_s.humanize
        @hidden = false
        @hidden = hash[:hidden] if hash[:hidden]

        if hash[:options]
          @options = hash[:options]
          @title = hash[:options][:title] if hash[:options][:title]          
        end        
      end
    end
  end
end