# -*- encoding : utf-8 -*-
module Uzcommon::CommonHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def br_text text
    text.gsub("\r\n", "<br>").gsub("\n", "<br>")
  end

  def touch_device?
    user_agent = request.headers["HTTP_USER_AGENT"]
    (user_agent.present? && user_agent =~ /\b(Android|iPhone|iPad|Windows Phone|Opera Mobi|Kindle|BackBerry|PlayBook)\b/i)
  end
end
