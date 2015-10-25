class OptInMailer < ApplicationMailer

  def optin_mail(helper)
    @helper = helper
    mail(to: @helper.email, subject: I18n.t("optin_mail"))
  end
end
