SETTINGS = {
  :app_host   => "localhost:3000",
  :email      => {
    :from => "fromaddress@example.com",
    :contact_submission_recipient => "test@example.com"
  }
} unless defined?(SETTINGS)
