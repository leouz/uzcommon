require "uz_admin/meta/relationship"
require "uz_admin/meta/filter"
require "uz_admin/meta/custom_page"
require "uz_admin/meta/field"
require "uz_admin/meta/link"

module UzAdmin
  class Meta    
    attr_accessor :class, :name, :humanized_name, :humanized_name_plural, :symbol, :css_wrapper_class
    attr_accessor :sort, :base_path, :index_fields, :populate_batch_count, :title_field
    attr_accessor :fields, :relationships, :custom_pages, :filters, :links
        
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
      @css_wrapper_class = "uz_admin-#{@symbol}"
    end

    def initialize_other_args hash
      @sort = 'created_at DESC'
      @sort = hash[:sort] if hash[:sort]

      @base_path = @symbol.pluralize
      @base_path = hash[:base_path] if hash[:base_path]

      @index_fields = @fields.select{ |i| !i.hidden }.map{ |i| i.name }
      @index_fields = hash[:index_fields] if hash[:index_fields] and hash[:index_fields].any?

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
      
      def add_hidden_field name, type        
        @fields << Field.new({name: name, type: type, hidden: true, read_only: true}) if !@fields.any?{ |i| i.name == name }
      end
      
      add_hidden_field :id, :integer
      add_hidden_field :created_at, :datetime
      add_hidden_field :updated_at, :datetime
      
      @relationships = []
      hash[:relationships].each do |f| 
        r = Relationship.new(f) 
        @relationships << r
        add_hidden_field r.fk_field_name, :integer if r.type == :belongs_to
      end

      @filters = []    
      hash[:filters].each{ |f| @filters << Filter.new(f) }    

      @custom_pages = []      
      hash[:custom_pages].each{ |f| @custom_pages << CustomPage.new(f) } if hash[:custom_pages] != nil

      @links = []      
      hash[:links].each{ |f| @links << Link.new(f) } if hash[:links] != nil
    end
  end
end