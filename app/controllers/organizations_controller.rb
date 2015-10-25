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
    @orga_member = OrgaMember.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  def create
    @organization = Organization.new(organization_params)
    @orga_member = OrgaMember.new params[:organization][:orga_member].permit(:email, :password, :password_confirmation)
    begin
      ActiveRecord::Base.transaction do
        if @organization.save
          @orga_member.organization = @organization
          if @orga_member.save
            sign_in @orga_member
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
