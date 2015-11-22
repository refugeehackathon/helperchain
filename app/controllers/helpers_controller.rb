class HelpersController < ApplicationController
  authorize_resource
  require 'securerandom'

  def new
    @project = Project.friendly.find params[:project_id]
    @helper = Helper.new
    @title = I18n.t("project.subscribe_to", project: @project.name)
  end

  def create
    @project = Project.friendly.find params[:project_id]
    @helper = Helper.new params[:helper].permit(:email)
    @helper.project = @project
    @helper.confirmation_key = SecureRandom.urlsafe_base64
    if @helper.save
      HelperMailer.optin_mail(@helper).deliver_later
      redirect_to root_path, flash:{success: I18n.t("helpers.join_success")}
    else
      @title = I18n.t("project.subscribe_to", project: @project.name)
      render "new"
    end
  end

  def confirm
    @helper = Helper.find_by_confirmation_key params[:confirmation_key]
    unless @helper.nil?
      @helper.validated = true
      @helper.save
      Rails.logger.info("Subscription")
      redirect_to root_path, flash:{success: I18n.t("helpers.confirmed")}
    else
      redirect_to root_path, flash:{danger: I18n.t("helpers.no_confirmation")}
    end
  end

  def delete
    email = params[:email] || (params[:helper] && params[:helper][:email])
    @helper = Helper.find_by_email email
    unless @helper.nil?
      confirmation_key = params[:confirmation_key]
      if confirmation_key == @helper.confirmation_key
        Rails.logger.info("Unsubscription")
        @helper.delete
        redirect_to root_path, flash:{success: I18n.t("helpers.leave_success")}
      else
        HelperMailer.optout_mail(@helper).deliver_later
        redirect_to root_path, flash:{success: I18n.t("helpers.optout_sent")}
      end
    else
      # Success because otherwise it is possible to determine whether
      # an email is present in our system
      redirect_to root_path, flash:{success: I18n.t("helpers.optout_sent")}
    end
  end
end
