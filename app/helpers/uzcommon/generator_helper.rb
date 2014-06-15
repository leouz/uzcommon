module Uzcommon::GeneratorHelper
  protected

  def init_base params
    @params = params    
    initialize_model
    initialize_path if  @params.first && @params.first.start_with?("/")
    initialize_columns_from_params unless @params.empty?               
    # initialize_columns_from_meta if can_constantize
    debugger
    @columns = @params_columns || @meta_columns    
  end

  def initialize_model
    @model_name = @params.first
    @params = @params - [@params.first]

    @model_name = @model_name.camelize
  end

  def initialize_path
    @path = @params.first
    @params = @params - [@params.first]
  end

  MAPPINGS = [
      { type: "binary",    input: "string",    display: "string"    },
      { type: "boolean",   input: "checkbox",  display: "boolean"   },

      { type: "date",      input: "date",      display: "date"      },
      { type: "datetime",  input: "datetime",  display: "datetime"  },      
      { type: "time",      input: "time",      display: "time"      },
      { type: "timestamp", input: "datetime",  display: "datetime"  },
      
      { type: "decimal",   input: "currency",  display: "currency"  },

      { type: "float",     input: "number",    display: "number"    },
      { type: "integer",   input: "number",    display: "number"    },

      { type: "string",    input: "string",    display: "string"    },
      { type: "string",    input: "permalink", display: "link"      },
      { type: "string",    input: "email",     display: "string"    },
      { type: "string",    input: "file",      display: "file"      },
      { type: "string",    input: "image",     display: "image"     },
      { type: "string",    input: "password",  display: nil         },
      
      { type: "text",      input: "text",      display: "text"      },
      { type: "text",      input: "wysi",      display: "wysi"      }
    ]

  def get_mapping_by_type type
    matches = MAPPINGS.select{ |m| m[:type] == type }
    matches.first unless matches.empty?
  end

  def get_mapping_by_input input
    matches = MAPPINGS.select{ |m| m[:input] == input }
    matches.first unless matches.empty?
  end

  def create_view_model name, mapping, options=nil
    r = { name: name }.merge(mapping)
    r.merge(options) if options
    r
  end

  def initialize_columns_from_params 
    @params_columns = @params.map do |p|       
      split = p.split(":").map{ |i| i.downcase }      
      mapping = get_mapping_by_input split[1]
      mapping = get_mapping_by_type split[1] unless mapping        

      options = {
        required: (["r", "required"] & split).present?,
        unique: (["u", "unique"] & split).present?,
        no_spaces: (["ns", "no-spaces"] & split).present?,
        index: (["i", "index"] & split).present?
      } 

      create_view_model split[0], mapping, options    
    end
  end

  def can_constantize    
    debugger
    @model = @model_name.constantize rescue false    
  end

  def initialize_columns_from_meta
    def excluded?(name)
      %w[_id _type id created_at updated_at].include?(name) ||
      [ /.*_checksum/, /.*_count/ ].any? {|p| name =~ p } ||
      options['excluded_columns']||[].include?(name)
    end

    def map_form_type(c)      
      mapping = get_mapping_by_type c.type.to_s
      if c.type == :string
        if c.name.include? "permalink"
          mapping = get_mapping_by_input "permalink"
        elsif c.name.include? "email"
          mapping = get_mapping_by_input"email"
        elsif @instance.methods.any?{ |m| m == "#{c.name}_url".to_sym }
          mapping = get_mapping_by_input "file"  
          if c.name.include?("image") || c.name.include?("photo") || yes?("Is #{c.name} an image?")                   
            mapping = get_mapping_by_input "image" 
          end
        end
      end
      create_view_model c.name, mapping
    end

    @instance = @model.new
    
    @meta_columns = @model.columns.reject{|c| excluded?(c.name) }.map{|c| map_form_type(c)}          
  end

  def generate_migrations columns
    #TODO
    # Rails::Generators.invoke("active_record:model", [name, "list_order:string", "name:string"], {migration: true, timestamps: true})
  end

  def attr_accessible columns
    attr_accessible = columns.map{ |m| ":#{m[:name]}" } * ", "
  end

  def template_view template_name
    path = "app/views"
    path = path + @path if @path
    template "#{template_name}.erb", File.join(path, @model_name.underscore.pluralize, template_name)
  end 

  def template_controller template_name
    path = "app/controllers"
    path = path + @path if @path
    template "#{template_name}.erb", File.join(path, "#{@model_name.underscore.pluralize}_controller.rb")
  end

  def template_model template_name
    template "#{template_name}.erb", File.join('app/model', @model_name.underscore, template_name)
  end 

  def template_uploader template_name, uploader_model_name
    template "#{template_name}.erb", File.join('app/uploader',  "#{uploader_model_name.underscore}.rb" )
  end 
end

