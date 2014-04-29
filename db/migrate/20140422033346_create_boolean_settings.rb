# -*- encoding : utf-8 -*-
class CreateBooleanSettings < ActiveRecord::Migration
  def change
    create_table :boolean_settings do |t|
      t.string :type
      t.integer :setting_group_id
      t.string :key, unique: true
      t.string :display_name, unique: true      
      t.string :hint
      t.boolean :has_user_changed, default: false
      
      t.boolean :value
      t.timestamps
    end
  end
end
