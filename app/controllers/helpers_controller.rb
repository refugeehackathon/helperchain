class HelpersController < ApplicationController
  def create
    @helper = Helper.new params[:helper].permit(:email, :location)
    @helper.lat = 0
    @helper.long = 0
    if @helper.save
      redirect_to root_path, notice: 'You will receive an e-mail with your account activation link.'
    else
      redirect_to root_path, flash:{warning: 'An error occured.'}
    end
  end

  def delete
  end
end
