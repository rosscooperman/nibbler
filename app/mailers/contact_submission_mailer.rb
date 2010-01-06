class ContactSubmissionMailer < ActionMailer::Base
  def submission(submission, sent_on = Time.now.utc)
    from "#{submission.name} <#{SETTINGS[:email][:contact_submission_recipient]}>"
    sent_on sent_on
    reply_to    "#{submission.email}"
    recipients  SETTINGS[:email][:contact_submission_recipient]
    subject     submission.subject
    body        :submission => submission
  end
end