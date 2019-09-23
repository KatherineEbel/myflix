class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:mailgun).dig(:username)
  layout 'mailer'
end
