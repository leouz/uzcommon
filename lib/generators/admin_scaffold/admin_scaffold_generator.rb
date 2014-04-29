# class AdminScaffoldGenerator < Rails::Generators::Base
#   source_root File.expand_path('../templates', __FILE__)
#   include Uzcommon::GeneratorHelper

#   argument :model_name, :type => :string, :required => true
#   argument :params, :type => :array, :required => true

#   def generate       
#     @model_name = format_model_name model_name   
#     @columns = columns model_name, params
    

#     generate_migrations @columns
    
#     template_admin_controller "controller.rb"
#   end
# end
