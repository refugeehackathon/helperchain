class RequestMailer < ApplicationMailer
  layout 'helper_mailer'

  def no_more_helpers request
    @request = request
    mail to: request.member_in_charge.email
  end

  def request_done request
    @request = request
    mail to: request.member_in_charge.email
  end

  def helper_request request_status
    @request_status = request_status
    @request = request_status.request
    @helper = @request_status.helper
    mail to: @helper.email, subject: I18n.t("request_mailer.helper_request.subject", project: @request.project.name)
  end
end
