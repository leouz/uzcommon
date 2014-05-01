# -*- encoding : utf-8 -*-
class CreateSettingGroups < ActiveRecord::Migration
  def change
    create_table :setting_groups do |t|
      t.string :key, :unique => true
      t.string :display_name, :unique => true
      t.string :main_group

      t.timestamps
    end    
  end
end
