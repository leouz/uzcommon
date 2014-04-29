# -*- encoding : utf-8 -*-
class TextSetting < ActiveRecord::Base
  attr_accessible :display_name, :hint, :key, :value, :user_has_changed  
  belongs_to :group, class_name: "SettingGroup", :foreign_key => :setting_group_id
end
