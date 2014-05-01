class UzGalleryScaffoldGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  include Uzcommon::GeneratorHelper  
  argument :params, :type => :array, :required => true
  
  def generate    
    template_admin_view "index.html.haml"
    template_admin_view "new.html.haml"
    template_admin_view "edit.html.haml"
    template_admin_view "_form.html.haml"
  end 
end