class AdminScaffoldGalleryGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  include Uzcommon::GeneratorHelper

  argument :model_name, :type => :string, :required => true
  
  def generate
    @model_name = format_model_name model_name
    @columns = columns model_name, true    
    @attr_accessible = attr_accessible @columns

    @uploader_col = @columns.select!{ |c| c[:form_type] == "image" }.first.name
    @uploader_model_name = "#{@model_name.pluralize}#{@uploader_col.capitalize}"

    create_view "index.html.haml", @model_name
    create_controller "controller.rb", @model_name
    create_model "model.rb", @model_name
    create_uploader "uploader.rb", @uploader_model_name
  end 
end

 # class_option :stylesheet, :type => :boolean, :default => true, :description => "Include stylesheet file"  
 #  def generate_layout
 #    copy_file "stylesheet.css", "public/stylesheets/#{file_name}.css" if options.stylesheet?