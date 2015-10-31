class RequestsController < ApplicationController
  load_and_authorize_resource
  before_action :set_organization
  before_action :set_request, only: [:show, :edit, :update, :destroy]

  # GET /requests/1
  def show
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
  end

  # POST /requests
  def create
    @request = @organization.requests.new(request_params)
    loc = Geokit::Geocoders::GoogleGeocoder.geocode "#{@request.town}, #{@request.street}"
    @request.lat = loc.lat
    @request.long = loc.lng

    if @request.save
      redirect_to @request, notice: 'Request was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /requests/1
  def update
    if @request.update(request_params)
      redirect_to @request, notice: 'Request was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /requests/1
  def destroy
    @request.destroy
    redirect_to requests_url, notice: 'Request was successfully destroyed.'
  end

  private
  def set_organization
    @organization = current_orga_member.organization
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = @organization.requests.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def request_params
    params.require(:request).permit(:name, :description, :lat, :long, :amount, :start, :end, :timeout, :range, :organization_id, :town, :street, :address_information)
  end
end
