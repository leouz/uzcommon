require "uz_admin/helpers"
require "uz_admin/meta"
require 'active_support/concern'

module UzAdmin
  extend ActiveSupport::Concern 

  included do
  end 

  module ClassMethods
    def uz_admin(hash)
      @@meta ||= {}
      
      if @@meta[self.name].nil?        
        m = Meta.new(hash)
        @@meta[self.name] = m

        m.fields.each do |f|
          attr_accessible f.name
          mount_uploader(f.name, "#{m.name}#{f.name.to_s.camelize}Uploader".constantize) if f.type == :image
        end

        m.relationships.each do |r|
          if r.type == :has_many
            has_many r.field, :dependent => :destroy  
            accepts_nested_attributes_for r.field, :allow_destroy => true
          end
          belongs_to r.field if r.type == :belongs_to      
        end
      end
    end

    def meta      
      @@meta[self.name]
    end
  end
end

ActiveRecord::Base.send(:include, UzAdmin)