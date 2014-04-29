# -*- encoding : utf-8 -*-
class ImageSetting < StringSetting
  mount_uploader :value, ImageSettingUploader  
end
