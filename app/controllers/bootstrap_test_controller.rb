class BootstrapTestController < ActionController::Base
  def index
    render layout: false
  end
end