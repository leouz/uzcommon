module Uzcommon::UzSettingsHelper
  def setting group_key, key
    UzSettings.setting(group_key, key)
  end

  def image_setting group_key, key, format=nil
    UzSettings.image(group_key, key, format)
  end
end

