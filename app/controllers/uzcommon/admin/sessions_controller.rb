# -*- encoding : utf-8 -*-
class Uzcommon::Admin::SessionsController < UzcommonControllerBase
  layout 'admin'
  def new        
    redirect_to uzcommon.admin_settings_group_path if admin?
  end

  def create
    session[:password] = params[:password]
    
    if admin?
      flash[:notice] = "Successfully logged in";
      redirect_to uzcommon.admin_settings_group_path
    else
      flash[:error] = "Wrong password!";
      redirect_to uzcommon.admin_root_path
    end    
  end
  
  def destroy
    reset_session
    flash[:notice] = "Successfully logged out";
    redirect_to uzcommon.admin_root_path
  end
end
