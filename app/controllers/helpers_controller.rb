class HelpersController < ApplicationController
  authorize_resource
  before_filter :get_project
  require 'securerandom'

  def new
    raise CanCan::AccessDenied unless params[:invite_key] == @project.invite_key
    @helper = Helper.new
    @title = I18n.t("project.subscribe_to", project: @project.name)
  end

  def create
    raise CanCan::AccessDenied unless params[:invite_key] == @project.invite_key
    @helper = Helper.new params[:helper].permit(:email)
    @helper.project = @project
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

  def subscribe_many
    @title = I18n.t "helpers.subscribe_many"
  end

  def subscribe_many_post
    @sent_mails_to = []
    mails = parse_emails params[:helpers][:mails]
    mails.each do |email|
      new_helper = Helper.new email: email
      new_helper.project = @project
      if new_helper.valid?
        @sent_mails_to << email
        new_helper.save
        HelperMailer.optin_mail(new_helper).deliver_later
      end
    end
    if @sent_mails_to.empty?
      redirect_to project_helpers_subscribe_many_path(@project), flash: {warning: I18n.t("helpers.no_helpers_subscribed")}
    else
      @title = I18n.t "helpers.subscription_successfull"
      render "subscription_successfull"
    end
  end

  def unsubscribe_many
    @title = I18n.t "helpers.unsubscribe_many"
  end

  def unsubscribe_many_post
    mails = parse_emails params[:helpers][:mails]
    mails.each do |email|
      helper = @project.helpers.find_by_email email
      helper.destroy
    end
    redirect_to project_path(@project), flash: {success: I18n.t("helpers.unsubscription_successfull")}
  end

  def unsubscribe
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
  private
  def get_project
    @project = Project.friendly.find params[:project_id]
  end

  def parse_emails emails
    emails.split(/[\n ,;]/)
  end
end
