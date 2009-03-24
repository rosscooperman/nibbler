require 'digest/sha1'
module Authenticated
  
  module ClassMethods
    # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
    def authenticate_by_auth_hash(id, hash)
      u = find(:first, :conditions => ["UPPER(id) = UPPER(?)", id]) # need to get the salt
      u && u.password_reset_hash == hash ? u : nil
    end

    def authenticate(email, password)
      u = find(:first, :conditions => ["UPPER(email) = UPPER(?)", email]) # need to get the salt
      u && u.authenticated?(password) ? u : nil
    end
    
    # Encrypts some data with the salt.
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end
  end
  
  def self.included(base)
    base.extend ClassMethods
    
    base.class_eval do
      # Virtual attribute for the unencrypted password
      attr_accessor :password
      attr_accessor :current_password

      validates_presence_of     :username
      validates_uniqueness_of   :username, :case_sensitive => false
      validates_presence_of     :email
      validates_uniqueness_of   :email, :case_sensitive => false
      # validates_presence_of     :email_confirmation
#      validates_confirmation_of :email
      validates_length_of       :email,    :within => 3..100
      validates_presence_of     :password,                    :if => :password_required?
      validates_presence_of     :password_confirmation,       :if => :password_required?
      validates_length_of       :password, :within => 6..40,  :if => :password_required?
      validates_confirmation_of :password,                    :if => :password_required?
#      validates_acceptance_of   :terms_of_service
      before_save :encrypt_password
    end
  end
  
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me!
    remember_me_for! 2.weeks
  end

  def remember_me_for!(time)
    remember_me_until! time.from_now.utc
  end

  def remember_me_until!(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me!
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def password_reset_hash
    Digest::SHA1.hexdigest("--I<3SM--#{email}--")
  end

protected
  
  # before save 
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
    self.crypted_password = encrypt(password)
  end
  
  def password_required?
    crypted_password.blank? || !password.blank?
  end
  
end