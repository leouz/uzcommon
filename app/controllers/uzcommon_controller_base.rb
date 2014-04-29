# -*- encoding : utf-8 -*-
class UzcommonControllerBase < ActionController::Base      
  before_filter :prepare_for_mobile 
  private

  def admin?
    session[:password] == ENV["ADMIN_PASSWORD"]
  end
  helper_method :admin?

  def mobile_device?
    session[:mobile_param] and session[:mobile_param] == "1"    
  end
  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device? and !request.env['PATH_INFO'].starts_with?('/admin')
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end 
end
