# -*- encoding : utf-8 -*-
class CreateStringSettings < ActiveRecord::Migration
  def change
    create_table :string_settings do |t|
      t.string :type
      t.integer :setting_group_id
      t.string :key, unique: true
      t.string :display_name, unique: true
      t.string :value
      t.string :hint
      t.boolean :has_user_changed, default: false

      t.timestamps
    end
  end
end
