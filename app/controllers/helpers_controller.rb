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
      OptInMailer.optin_mail(@helper).deliver
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
