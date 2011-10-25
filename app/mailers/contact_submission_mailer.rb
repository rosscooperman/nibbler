class ContactSubmissionMailer < ActionMailer::Base
  
  def submission(submission, sent_on = Time.now.utc)
    @submission =  submission

    mail(
      :from     => "#{submission.name} <#{SETTINGS[:email][:contact_submission_recipient]}>",
      :sent_on  => sent_on.to_s,
      :reply_to => "#{submission.email}",
      :to       => SETTINGS[:email][:contact_submission_recipient],
      :subject  => submission.subject
    )
  end
end