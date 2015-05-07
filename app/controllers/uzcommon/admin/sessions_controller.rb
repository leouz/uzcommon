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
      if UZ_ADMIN_DASHBOARD
        redirect_to uzcommon.admin_dashboard
      else
        redirect_to uzcommon.admin_settings_group_path
      end
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
