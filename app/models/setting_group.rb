# -*- encoding : utf-8 -*-
class SettingGroup < ActiveRecord::Base
  attr_accessible :display_name, :main_group, :key

  ["string", "image", "file", "text", "boolean"].each do |t|
    t_plural = t + "s"

    has_many t_plural.to_sym, class_name: "#{t.capitalize}Setting", dependent: :destroy  
    accepts_nested_attributes_for t_plural.to_sym, allow_destroy: true  
    
    
    define_method("create_#{t}") do |params|
      if (t == "image" or  t == "file") and params[:value]
        params[:value] = File.open(File.join(Rails.root, "/db/seed-files/" + params[:value]))
      end

      s = self.send(t_plural).find_by_key(params[:key])
      if s
        s.update_attributes(params) if !s.has_user_changed
      else
        s = self.send(t_plural).create params
      end
    end
  
  end

  def self.get_setting group_key, key
    g = get_group group_key
    s = nil
    if g
      ["strings", "files", "texts", "booleans"].each do |t|        
        s = g.send(t).find_by_key(key)
        break if s
      end
      
      if s
        s.value
      else
        raise "Setting '#{key}' not found in '#{group_key}' SettingGroup."
      end
    end
  end

  def self.seeds_create params
    g = SettingGroup.find_or_initialize_by_key params[:key]
    g.update_attributes(params) 
    g   
  end

  def self.get_image group_key, key, format=nil        
    g = get_group group_key
    if g
      f = g.images.find_by_key(key)
      if f
        format ? f.value_url(format) : f.value_url
      else
        raise "ImageSetting '#{key}' not found in '#{group_key}' SettingGroup."
      end
    end
  end

  def get_settings type
    self.send(type + "s")
  end

  def self.reset
    SettingGroup.destroy_all
    StringSetting.destroy_all
    BooleanSetting.destroy_all
    TextSetting.destroy_all
  end

  private

  def self.get_group group_key
    g = SettingGroup.find_by_key(group_key)
    raise "SettingGroup '#{group_key}' not found" unless g
    g
  end
end
