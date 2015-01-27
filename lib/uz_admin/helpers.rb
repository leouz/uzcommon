module UzAdmin
  module Helpers
    def self.find base_path      
      all.find{ |m| m.base_path == base_path }
    end

    def self.all
      UZ_ADMIN.map{ |m| m.meta }
    end
  end
end