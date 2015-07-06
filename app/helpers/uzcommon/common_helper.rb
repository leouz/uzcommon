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

  def convert_to_video_embed_link link
    link = link.gsub('https://', '').gsub('http://', '')

    youtube_link = '//www.youtube.com/embed/'
    vimeo_link = '//player.vimeo.com/video/'
    
    result = vimeo_link + link.gsub('vimeo.com/', '') if link.include?('vimeo.com/')    
    result = youtube_link + link.gsub('www.youtube.com/watch?v=', '') if link.include?('www.youtube.com/watch?v=')    
    result = youtube_link + link.gsub('youtu.be/', '') if link.include?('youtu.be/')
    
    result   
  end  
end
