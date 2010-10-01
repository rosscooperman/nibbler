# Rails doesn't preload STI classes, which has led to the following bug:
#
#    class Writer < ActiveRecord::Base; end
#    class Administrator < Writer; end
#
#    >> Writer.find_by_email("admin@flavorpill.net")
#    => nil
#    >> Administrator # load the class
#    => Administratorid: integer, created_at: datetime, updated_at: datetime, last_synced_at: datetime, phone: string, crypted_password: string, salt: string, remember_token: string, remember_token_expires_at: datetime, birthday: date, gender: string, postal_code: string, country: string, security_question: string, security_answer: string, subscriber_hash: string, primary_email_id: integer, name: string, became_member_at: datetime, city: string, mobile_number: string, type: string, fb_user_id: integer, fb_email_hash: string, description: text, source: string, completed_basic_info: boolean, completed_avatar: boolean
#    >> Administrator.find_by_email("admin@flavorpill.net")
#    => #<Administrator id: 292114 .. >
#
# Also, see this bug report:
#
#  https://rails.lighthouseapp.com/projects/8994/tickets/2575-not-eager-loading-application-classes-causes-sti-breakage
module EagerLoader
  extend self

  def self.load
    require_model "administrator"
  end

private

  def require_model(model_name)
    require_dependency File.join(Rails.root, "app", "models", model_name)
  end
end
