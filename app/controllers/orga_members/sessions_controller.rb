class OrgaMembers::SessionsController < Devise::SessionsController

  # GET /resource/sign_in
  def new
    @title = I18n.t "orga.login"
    super
  end

  # POST /resource/sign_in
  def create
    @title = I18n.t "orga.login"
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
