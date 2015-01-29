module UzAdmin
  class Meta  
    class Link
      attr_accessor :name, :href, :target

      def initialize hash        
        @name = hash[:name].to_s
        @href = hash[:href]
        @target = "_self"                

        if hash[:options]
          @target = hash[:options][:target] if hash[:options][:target]          
        end
      end     
    end
  end
end