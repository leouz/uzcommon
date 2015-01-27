require "uz_admin/helpers"
require "uz_admin/meta"
require "uz_admin/meta_builder"
require 'active_support/concern'

module UzAdmin
  extend ActiveSupport::Concern 

  module ActiveRecord
    def uz_admin selfie, &block
      @@meta ||= {}
            
      if @@meta[self.name].nil?        
        m = MetaBuilder.new(selfie)
        yield(m)
        @@meta[self.name] = m.build
        @meta = m.build
      end
            
      m = @@meta[self.name]        
      m.fields.each do |f|
        attr_accessible f.name
        mount_uploader(f.name, "#{m.name}#{f.name.to_s.camelize}Uploader".constantize) if f.type == :image or f.type == :file
      end

      m.relationships.each do |r|
        if [:has_many, :has_one].include? r.type
          has_many r.field, r.class_declaration_options if r.type == :has_many
          has_one r.field, r.class_declaration_options if r.type == :has_one
          accepts_nested_attributes_for r.field, allow_destroy: true
        end
        belongs_to r.field, r.class_declaration_options if r.type == :belongs_to              
      end        
    
      include UzAdmin
    end
  end

  included do |base|    
  end

  module ClassMethods
    def meta      
      @meta
    end
  end
end

ActiveRecord::Base.extend(UzAdmin::ActiveRecord)
