class ContactSubmissionsController < ApplicationController
  make_resourceful do
    actions :create

    response_for :create do
      flash_message(:contact_submission, :success)
      redirect_to new_contact_submission_path
    end
  end

  def index
    redirect_to new_contact_submission_path
  end

  def new
    @contact_submission = ContactSubmission.new

    if logged_in?
      @contact_submission.email = current_user.email
    end
  end
end
