# class AdminViewsGenerator < Rails::Generators::Base
#   source_root File.expand_path('../templates', __FILE__)
#   include Uzcommon::GeneratorHelper

#   argument :model_name, :type => :string, :required => true
  
#   def generate
#     @model_name = format_model_name model_name
#     @columns = columns model_name, true

#     template_admin_view "index.html.haml"
#     template_admin_view "new.html.haml"
#     template_admin_view "edit.html.haml"
#     template_admin_view "_form.html.haml"
#   end 

#   private
  
# end