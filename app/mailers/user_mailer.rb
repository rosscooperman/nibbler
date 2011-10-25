class UserMailer < ActionMailer::Base
  helper :shared
  default :from => SETTINGS[:email][:from]

  def signup(user, sent_on = Time.now.utc)
    @user = user

    mail :to => user.email, :subject => "Welcome", :sent_on => sent_on.to_s
  end

  def password_reset_link(user, sent_on = Time.now.utc)
    @user = user

    mail :to => user.email, :subject => "Create a new password", :sent_on => sent_on.to_s
  end
end