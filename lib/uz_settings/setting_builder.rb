class UzSettings
  class SettingBuilder
    def initialize group
      @group = group
    end

    SettingGroup.types.each do |type|
      define_method("#{type}") do |*args|        
        display_name, key, value, params = args
        default_params = { display_name: display_name, key: key, value: value }        
        default_params = default_params.merge(params) if params
        @group.create_setting(type, default_params)
      end
    end
  end
end
