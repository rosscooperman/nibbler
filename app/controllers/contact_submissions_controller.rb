class ContactSubmissionsController < ApplicationController

  def index
    redirect_to new_contact_submission_path
  end
  
  def new
    @contact_submission = ContactSubmission.new
    @contact_submission.email = current_user.email if logged_in?
  end

  def create
    @contact_submission = ContactSubmission.new(params[:contact_submission])
    if @contact_submission.save
      flash_message(:contact_submission, :success)
      redirect_to new_contact_submission_path
    else
      render :new
    end
  end
end
