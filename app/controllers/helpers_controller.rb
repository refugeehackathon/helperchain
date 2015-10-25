class HelpersController < ApplicationController
  def create
    @helper = Helper.new params[:helper].permit(:email, :location)
    @helper.lat = 0
    @helper.long = 0
    if @helper.save
      redirect_to root_path, flash:{success: I18n.t("join_success")}
    else
      redirect_to root_path, flash:{danger: I18n.t("join_error")}
    end
  end

  def createconfirmation
  end

  def delete
    @helper = Helper.delete params[:helper].permit(:email)
    if @helper.delete
      redirect_to root_path, flash:{success: I18n.t("leave_success")}
    else
      redirect_to root_path, flash:{danger: I18n.t("leave_error")}
    end
  end

  def deleteconfirmation
  end

end
