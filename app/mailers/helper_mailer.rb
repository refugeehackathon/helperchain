class HelperMailer < ApplicationMailer
  layout 'helper_mailer'

  def optin_mail(helper)
    @helper = helper
    mail(to: @helper.email, subject: I18n.t("mail.optin_subject"))
  end

  def optout_mail(helper)
    @helper = helper
    mail(to: @helper.email, subject: I18n.t("mail.optout_subject"))
  end
end
