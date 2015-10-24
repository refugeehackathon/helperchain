# coding: utf-8
class OrganizationsController < ApplicationController
  load_and_authorize_resource
  before_action :set_organization, only: [:show, :edit, :update]

  # GET /organizations
  def index
    @organizations = Organization.all
  end

  # GET /organizations/1
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
    @user = User.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  def create
    @organization = Organization.new(organization_params)
    @user = User.new params[:organization][:user].permit(:email, :password, :password_confirmation)
    begin
      ActiveRecord::Base.transaction do
        if @organization.save
          @user.organization = @organization
          if @user.save
            sign_in @user
            redirect_to @organization, notice: 'Organization was successfully created.'
          else
            throw "error"
          end
        else
          throw "error"
        end
      end
    rescue
      render :new
    end
  end

  # PATCH/PUT /organizations/1
  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: 'Organization was successfully updated.'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def organization_params
      params.require(:organization).permit(:name)
    end
end
