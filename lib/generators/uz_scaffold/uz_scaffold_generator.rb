class UzScaffoldGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  include Uzcommon::GeneratorHelper  
  argument :params, :type => :array, :required => true
  
  def generate    
    init_base params
    template_view "index.html.haml"
    template_view "new.html.haml"
    template_view "edit.html.haml"
    template_view "_form.html.haml"
    # template_controller "controller.rb"
  end 
end