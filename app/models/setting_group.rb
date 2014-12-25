# -*- encoding : utf-8 -*-
class SettingGroup < ActiveRecord::Base
  attr_accessible :display_name, :main_group, :key

  def self.types
    ["string", "image", "file", "text", "boolean"]
  end

  self.types.each do |type|
    type_plural = type.pluralize
    has_many type_plural.to_sym, class_name: "#{type.capitalize}Setting", dependent: :destroy  
    accepts_nested_attributes_for type_plural.to_sym, allow_destroy: true  
  end
    
  def create_setting type, params
    if ["image", "file"].include?(type) and params[:value]
      params[:value] = File.open(File.join(Rails.root, "/db/seed-files/" + params[:value]))
    end

    type_plural = type.pluralize

    s = self.send(type_plural).find_by_key(params[:key])
    if s
      s.update_attributes(params) if !s.has_user_changed
    else
      s = self.send(type_plural).create params
    end
  end   

  def settings
    result = []
    self.types.each do |type|
      type_plural = type.pluralize
      result << self.send(type_plural).all
    end
  end

  # def self.reset
  #   StringSetting.destroy_all
  #   BooleanSetting.destroy_all
  #   TextSetting.destroy_all
  #   SettingGroup.destroy_all
  # end

  def self.find_group group_key
    g = SettingGroup.find_by_key(group_key)
    raise "SettingGroup '#{group_key}' not found" unless g
    g
  end
end
