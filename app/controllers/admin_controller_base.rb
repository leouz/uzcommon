# -*- encoding : utf-8 -*-
class AdminControllerBase < UzcommonControllerBase
  layout 'admin'
  before_filter :require_login 

  def require_login
    unless admin?
      flash[:error] = "You must be logged in to access this section"
      redirect_to admin_login_path
    end
  end
end
