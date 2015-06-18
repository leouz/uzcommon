require "uz_settings/setting_builder"

class UzSettings
  class GroupBuilder
    def initialize main_group
      @main_group = main_group
    end

    def group key, display_name, &block
      group = SettingGroup.new key: key
      group.update_attributes(main_group: @main_group, key: key, display_name: display_name)
      yield SettingBuilder.new(group)
    end
  end
end
