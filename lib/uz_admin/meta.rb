require "uz_admin/meta/relationship"
require "uz_admin/meta/filter"
require "uz_admin/meta/custom_page"
require "uz_admin/meta/field"

module UzAdmin
  class Meta    
    attr_accessor :class, :name, :humanized_name, :humanized_name_plural, :symbol
    attr_accessor :sort, :base_path, :index_fields, :populate_batch_count, :title_field
    attr_accessor :fields, :relationships, :custom_pages, :filters
        
    def initialize hash
      initialize_class_based_args hash
      initialize_list_args hash
      initialize_other_args hash      
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

    def find_custom_page name
      @custom_pages.detect{ |c| c.nested_path.to_s == name }
    end

    private

    def initialize_class_based_args hash
      @class = hash[:class]
      @name = @class.name.demodulize
      @humanized_name = @name.underscore.titleize
      @humanized_name_plural = @humanized_name.pluralize
      @symbol = @name.underscore
    end

    def initialize_other_args hash
      @sort = 'created_at DESC'
      @sort = hash[:sort] if hash[:sort]

      @base_path = @symbol.pluralize
      @base_path = hash[:base_path] if hash[:base_path]

      @index_fields = @fields
      @index_fields = @fields.select{ |f| hash[:index_fields].include?(f.name) } if hash[:index_fields]

      @can = [:create, :edit, :delete]
      @can = hash[:can] if hash[:can]

      @populate_batch_count = 10
      @populate_batch_count = hash[:populate_batch_count] if hash[:populate_batch_count]

      @title_field = :id
      @title_field = hash[:title_field] if hash[:title_field]
    end
    
    def initialize_list_args hash
      @fields = []
      hash[:fields].each{ |f| @fields << Field.new(f) }
      @fields << Field.new({name: :created_at, type: :date, hidden: true})
      @fields << Field.new({name: :updated_at, type: :date, hidden: true})

      @relationships = []    
      hash[:relationships].each{ |f| @relationships << Relationship.new(f) }

      @filters = []    
      hash[:filters].each{ |f| @filters << Filter.new(f) }    

      @custom_pages = []
      hash[:custom_pages].each{ |f| @custom_pages << CustomPage.new(f) } if hash[:custom_pages] != nil      
    end
  end
end