class ApplicationMailer < ActionMailer::Base
  default from: "QnA <#{Rails.application.credentials[Rails.env.to_sym][:email][:host_email]}>"
  layout 'mailer'
end
