module UzAdmin
  class Meta  
    class CustomPage
      attr_accessor :template, :target, :layout, :title, :nested_path

      def initialize hash        
        @template = hash[:template].to_s

        @target = "_self"
        @layout = true
        @title = @template.to_s.underscore.titleize
        @nested_path = @template.to_s

        if hash[:options]
          @target = hash[:options][:target] if hash[:options][:target]
          @layout = hash[:options][:layout] if hash[:options][:layout]
          @title = hash[:options][:title] if hash[:options][:title]                
          @nested_path = hash[:options][:nested_path].to_s if hash[:options][:nested_path]        
        end
      end     
    end
  end
end