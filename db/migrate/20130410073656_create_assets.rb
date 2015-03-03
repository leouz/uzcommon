# This migration comes from uzcommon (originally 20140306222108)
# -*- encoding : utf-8 -*-
class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :type
      t.string :group
      t.string :file

      t.timestamps
    end
  end
end
