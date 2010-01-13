class UserMailer < ActionMailer::Base
  helper :shared

  def signup(user, sent_on = Time.now.utc)
    from        SETTINGS[:email][:from]
    recipients  user.email
    subject     "Welcome"
    sent_on     sent_on

    body      :user => user
  end

  def password_reset_link(user, sent_on = Time.now.utc)
    from        SETTINGS[:email][:from]
    recipients  user.email
    subject     "Create a new password"
    sent_on     sent_on
    body        :user => user
  end
end
