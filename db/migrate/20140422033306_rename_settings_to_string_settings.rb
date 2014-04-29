# -*- encoding : utf-8 -*-
class RenameSettingsToStringSettings < ActiveRecord::Migration
  def change
    rename_table :settings, :string_settings
  end
end
