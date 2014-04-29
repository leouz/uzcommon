# -*- encoding : utf-8 -*-
class FileSetting < StringSetting
  mount_uploader :value, FileSettingUploader  
end
