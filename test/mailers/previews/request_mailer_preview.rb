# Preview all emails at http://localhost:3000/rails/mailers/request_mailer
class RequestMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/request_mailer/no_more_helpers
  def no_more_helpers
    RequestMailer.no_more_helpers
  end

  # Preview this email at http://localhost:3000/rails/mailers/request_mailer/request_done
  def request_done
    RequestMailer.request_done
  end

  # Preview this email at http://localhost:3000/rails/mailers/request_mailer/helper_request
  def helper_request
    RequestMailer.helper_request
  end

end
