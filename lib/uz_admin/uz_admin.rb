class UzAdmin
  attr_accessor :name, :humanized_name, :humanized_name_plural, :symbol, :class
  attr_accessor :fields, :relationships
  attr_accessor :sort, :base_path, :index_fields, :populate_batch_count

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
  end

  def can action
    @can.include?(action)
  end

  def form_fields
    @fields
  end

  def find_relationship nested_path
    @relationships.find{ |r| r.type == :has_many }
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
    attr_accessor :field, :type, :meta, :nested_path, :title_field
    def initialize(hash)
      @field = hash[:field]
      @type = hash[:type]
      @meta = hash[:meta]
      @nested_path = @meta.base_path      
      @nested_path = hash[:nested_path] if hash[:nested_path]

      @title_field = :id
      @title_field = hash[:title_field] if hash[:title_field]
    end     
  end

  def self.find base_path    
    all.find{ |m| m.base_path == base_path }
  end

  def self.all
    UZADMIN_METAS
  end
end