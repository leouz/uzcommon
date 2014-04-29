# -*- encoding : utf-8 -*-
module Uzcommon::SettingsHelper
  def setting group_key, key
    SettingGroup.get_setting(group_key, key)
  end

  def image_setting group_key, key, format=nil
    SettingGroup.get_image(group_key, key, format)
  end
end

