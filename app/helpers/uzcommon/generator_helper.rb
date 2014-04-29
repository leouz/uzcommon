module Uzcommon::GeneratorHelper     
  protected

  def initialize params
    @params = params
    initialize_model
    initialize_path
    initialize_columns_from_params
    initialize_columns_from_meta
  end

  def initialize_model
    @model_name = @params.first || raise_missing_arg "model"
    @params = @params - @params.first 
    @model_name = @model_name.camelize.singularize
  end

  def initialize_path
    if @params.first && @params.first.start_with("/")
      @path = @params.first
      @params = @params - @params.first
    end
  end

  MAPPINGS = [
      ["binary",   "string"],
      ["boolean",  "checkbox"],
      ["date",     "date"],
      ["datetime", "datetime"],
      ["decimal",  "currency"],
      ["float",    "number"],
      ["integer",  "number"],

      ["string", "string"],
      ["string", "permalink"],
      ["string", "email"],
      ["string", "file"],
      ["string", "image"],
      ["string", "password"],

      ["text", "text"],
      ["text", "wysi"],      

      ["time",      "time"],
      ["timestamp", "datetime"]
    ]

  def initialize_columns_from_params params
    @params_columns = params.map do |m| 
      
      split = m.split(":")      
      name, form_type = split[0], split[1]

      {
        type: MAPPINGS.select{ |t, ft| ft == form_type }.first.first,
        form_type: form_type,
        name: name,
        required: (["r", "required"] & split).present?,
        unique: (["u", "unique"] & split).present?,
        no_spaces: (["ns", "no-spaces"] & split).present?,
        index: (["i", "index"] & split).present?
      } 
    end
  end

  def initialize_columns_from_meta    
    def excluded?(name)
      %w[_id _type id created_at updated_at].include?(name) ||
      [ /.*_checksum/, /.*_count/ ].any? {|p| name =~ p } ||
      options['excluded_columns']||[].include?(name)
    end

    model = model_name.constantize
    instance = model.new

    model.columns.reject {|c| excluded?(c.name) }.map do |c| 
      r = { name: c.name, type: c.type }
      r[:form_type] = MAPPINGS[c.type]        
      if c.type == :string
        if c.name.include? "permalink"
          r[:form_type] = "permalink"
        elsif c.name.include? "email"
          r[:form_type] = "email"
        elsif instance.methods.any?{ |m| m == "#{c.name}_url".to_sym }
          r[:form_type] = "file"                     
          r[:form_type] = "image" if (["image", "photo"] & c.name).present? || yes? "Is #{c.name} an image?"
        end
      end
      r
    end
  end

  def generate_migrations columns
    #TODO
    Rails::Generators.invoke("active_record:model", [name, "list_order:string", "name:string"], {migration: true, timestamps: true})
  end

  def attr_accessible columns
    attr_accessible = columns.map{ |m| ":#{m[:name]}" } * ", "
  end

  def template_admin_view template_name, model_name
    template "#{template_name}.erb", File.join('app/views/admin', model_name.underscore.pluralize, template_name)
  end 

  def template_admin_controller template_name, model_name
    template "#{template_name}.erb", File.join('app/controllers/admin', "#{model_name.underscore.pluralize}_controller.rb")
  end

  def template_model template_name, model_name
    template "#{template_name}.erb", File.join('app/model', model_name.underscore, template_name)
  end 

  def template_uploader template_name, uploader_model_name
    template "#{template_name}.erb", File.join('app/uploader',  "#{uploader_model_name.underscore}.rb" )
  end 
end

