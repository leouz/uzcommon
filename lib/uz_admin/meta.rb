module UzAdmin
  class Meta
    attr_accessor :name, :humanized_name, :humanized_name_plural, :symbol, :class
    attr_accessor :fields, :relationships, :custom_pages, :filters
    attr_accessor :sort, :base_path, :index_fields, :populate_batch_count, :title_field

    def initialize(hash)
      @class = hash[:class]
      @name = @class.name.demodulize
      @humanized_name = @name.underscore.titleize
      @humanized_name_plural = @humanized_name.pluralize
      @symbol = @name.underscore
      
      @fields = []    
      hash[:fields].each{ |f| @fields << Field.new(f) } if hash[:fields] != nil

      @relationships = []    
      hash[:relationships].each{ |f| @relationships << Relationship.new(f) } if hash[:relationships] != nil

      @filters = []    
      hash[:filters].each{ |f| @filters << Filter.new(f) } if hash[:filters] != nil


      @sort = 'created_at DESC'
      @sort = hash[:sort] if hash[:sort]

      @base_path = @symbol.pluralize
      @base_path = hash[:base_path] if hash[:base_path]

      @index_fields = @fields
      @index_fields = @fields.select{ |f| hash[:index_fields].include?(f.name) }  if hash[:index_fields]

      @can = [:create, :edit, :delete]
      @can = hash[:can] if hash[:can]

      @populate_batch_count = 10
      @populate_batch_count = hash[:populate_batch_count] if hash[:populate_batch_count]

      @title_field = :id
      @title_field = hash[:title_field] if hash[:title_field]

      @custom_pages = []
      hash[:custom_pages].each{ |f| @custom_pages << CustomPage.new(f) } if hash[:custom_pages] != nil      
    end

    def can action
      @can.include?(action)
    end

    def form_fields
      @fields
    end

    def find_relationship nested_path      
      @relationships.find{ |r| r.type == :has_many and r.field.to_s == nested_path }
    end  

    class Field
      attr_accessor :name, :type, :options
      def initialize(hash)
        @name = hash[:name]
        @type = hash[:type]     
        @options = {}
        @options = hash[:options] if hash[:options] != nil
      end

      def title
        @name.to_s.humanize
      end
    end

    class Relationship
      attr_accessor :field, :type, :class_name, :view_type

      def initialize(hash)      
        @hash = hash
        @field = hash[:field]
        @type = hash[:type]
        @class_name = hash[:class_name] 
        @view_type = hash[:view_type]       
      end

      def nested_path
        if @nested_path == nil
          @nested_path = meta.base_path
          @nested_path = @hash[:nested_path] if @hash[:nested_path]
        end
        @nested_path
      end 

      def humanized_name_plural
        @field.to_s.underscore.titleize.pluralize
      end

      def meta
        @class_name.constantize.meta      
      end
    end

    def find_custom_page name
      @custom_pages.detect{ |c| c.nested_path.to_s == name }
    end  

    class CustomPage
      attr_accessor :template, :target, :layout, :title, :nested_path

      def initialize(hash)      
        @hash = hash
        @template = hash[:template].to_s

        @target = "_self" #:new_tab :new_window
        @target = hash[:target] if hash[:target]

        @layout = true
        @layout = hash[:layout] if not hash[:layout].nil?

        @title = @template.to_s.underscore.titleize
        @title = hash[:title] if hash[:title]        

        @nested_path = @template.to_s
        @nested_path = hash[:nested_path].to_s if hash[:nested_path]        
      end      
    end

    class Filter
      attr_accessor :field, :type
      def initialize(hash)      
        @hash = hash
        @field = hash[:field]
        @type = hash[:type]      
      end
    end
  end
end