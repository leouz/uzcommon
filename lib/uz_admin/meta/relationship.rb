module UzAdmin
  class Meta      
    class Relationship
      attr_accessor :field, :type, :class_name, :view_type

      def initialize hash
        @hash = hash
        @field = hash[:field]
        @type = hash[:type]

        @class_name = @field.to_s.singularize.camelcase
        @view_type = nil
        @nested_path = nil      

        if hash[:options]          
          @class_name = hash[:options][:class_name] if hash[:options][:class_name]
          @nested_path = hash[:options][:nested_path] if hash[:options][:nested_path]
          @view_type = hash[:options][:view_type] if hash[:options][:view_type]
        end
      end

      def nested_path        
        @nested_path = meta.base_path if @nested_path == nil          
        @nested_path
      end 

      def humanized_name_plural
        @field.to_s.underscore.titleize.pluralize
      end

      def meta
        @class_name.constantize.meta      
      end
    end
  end
end