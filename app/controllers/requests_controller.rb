class RequestsController < ApplicationController
  load_and_authorize_resource
  before_action :set_organization, except: [:accept, :decline]
  before_action :set_request, only: [:show, :edit, :update, :destroy, :accept, :decline]

  # GET /requests/1
  def show
  end

  # GET /requests/new
  def new
    @request = Request.new organization: current_orga_member.organization, member_in_charge: current_orga_member, timeout: 5
  end

  # GET /requests/1/edit
  def edit
  end

  # POST /requests
  def create
    @request = @organization.requests.new(request_params)
    if @request.save
      Rails.logger.info("Request created")
      RequestWorker.perform_async(@request.id)
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

  def accept
    if request_status_ok?
      @request_status.accept
      Rails.logger.info("Request accepted")
      RequestWorker.perform_async(@request.id)
    end
  end

  def decline
    if request_status_ok?
      @request_status.decline
      Rails.logger.info("Request declined")
      RequestWorker.perform_async(@request.id)
    end
  end

  private
  def set_organization
    @organization = current_orga_member.organization
    raise ActiveRecord::RecordNotFound if @organization.nil?
  end

  def set_request
    id = params[:id] || params[:request_id]
    if @organization
      @request = @organization.requests.find(id)
    else
      @request = Request.find(id)
    end
    raise ActiveRecord::RecordNotFound if @request.nil?
  end

  def request_status_ok?
    @request_status = @request.request_statuses.joins(:helper).where { helpers.email == my{params[:email]} }.first
    raise ActiveRecord::RecordNotFound if @request_status.nil?
    if @request_status.timeout?
      render "timeout"
      return false
    end
    unless @request_status.accepted.nil?
      render "already_selected"
      return false
    end
    @request = @request_status.request
    return true
  end

  # Only allow a trusted parameter "white list" through.
  def request_params
    params.require(:request).permit(:name, :description, :lat, :long, :amount, :start, :end, :timeout, :range, :organization_id, :location, :address_information, :member_in_charge_id)
  end
end
