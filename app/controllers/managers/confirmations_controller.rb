class Managers::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  def new
    @title = I18n.t "manager.resend_confirmation"
    super
  end

  # POST /resource/confirmation
  def create
    @title = I18n.t "manager.resend_confirmation"
    super
  end
end
