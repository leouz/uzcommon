module UserSignup
  extend ActiveSupport::Concern
  
  included do
    attr_accessible :password, :password_confirmation, :expecting_response
    authenticates_with_sorcery!

    validates_presence_of :email
    validates_uniqueness_of :email
    validates :email, :email => true

    validates_length_of :password, :minimum => 3, :message => "password must be at least 3 characters long", :if => :password
    validates_confirmation_of :password, :message => "should match confirmation", :if => :password
  end  

  def has_confirmed_email
    self.email_confirmation_token == nil
  end

  def send_email_confirmation_mail
    self.email_confirmation_token = SecureRandom.urlsafe_base64(nil, false)
    UserMailer.email_confirmation(self).deliver if self.save
  end

  def change_email email    
    self.email = email    
    if self.save
      self.send_email_confirmation_mail 
    else
      false
    end
  end

  module ClassMethods
    def signup email, password, password_confirmation
      User.create(email: email, password: password, password_confirmation: password_confirmation)      
    end

    def load_from_email_confirmation_token token
      User::find_by_email_confirmation_token token
    end
  end

  def confirm_email
    self.email_confirmation_token = nil
    self.save
  end
end