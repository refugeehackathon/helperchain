class HelpersController < ApplicationController
  require 'geokit'
  require 'securerandom'
  def create
    @helper = Helper.new params[:helper].permit(:email, :location, :lat, :long)
    unless @helper.location.nil?
      loc = Geokit::Geocoders::GoogleGeocoder.geocode @helper.location
      @helper.lat = loc.lat
      @helper.long = loc.lng
    end
    @helper.confirmation_key = SecureRandom.urlsafe_base64
    if @helper.save
      HelperMailer.optin_mail(@helper).deliver
      redirect_to root_path, flash:{success: I18n.t("join_success")}
    else
      redirect_to root_path, flash:{danger: I18n.t("join_error")}
    end
  end

  def confirm
    @helper = Helper.find_by_confirmation_key params[:confirmation_key]

    unless @helper.nil?
      @helper.validated = true
      @helper.save
      redirect_to root_path, flash:{success: I18n.t("confirmed")}
    else
      redirect_to root_path, flash:{danger: I18n.t("no_confirmation")}
    end
  end

  def delete
    email = params[:email] || (params[:helper] && params[:helper][:email])
    @helper = Helper.find_by_email email
    unless @helper.nil?
      confirmation_key = params[:confirmation_key]
      if confirmation_key == @helper.confirmation_key
        @helper.delete
        redirect_to root_path, flash:{success: I18n.t("leave_success")}
      else
        HelperMailer.optout_mail(@helper).deliver
        redirect_to root_path, flash:{success: I18n.t("mail.optout_sent")}
      end
    else
      # Success because otherwise it is possible to determine whether
      # an email is present in our system
      redirect_to root_path, flash:{success: I18n.t("mail.optout_sent")}
    end
  end
end
