module UserSignupOauth
  extend ActiveSupport::Concern
  
  included do    
    has_many :providers, :class_name => "UserProvider", :dependent => :destroy
    accepts_nested_attributes_for :providers

    attr_accessible :providers_attributes
  end
  
  module ClassMethods
  end

end
