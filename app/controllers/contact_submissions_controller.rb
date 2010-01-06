class ContactSubmissionsController < ApplicationController
  make_resourceful do
    actions :new, :create

    response_for :create do
      flash_message(:contact_submission, :success)
      redirect_to new_contact_submission_path
    end
  end

  def index
    redirect_to new_contact_submission_path
  end
end
