class RequestsController < ApplicationController
  authorize_resource
  before_action :set_project, except: [:accept, :decline]
  before_action :set_request, only: [:show, :edit, :update, :destroy, :accept, :decline]

  def index
    @requests = @project.requests
    @requests = @requests.order(created_at: :desc)
    @title = I18n.t "request.manage_requests"
  end

  # GET /requests/1
  def show
    @title = @request.name
  end

  # GET /requests/new
  def new
    @request = Request.new project: current_manager.project, manager_in_charge: current_manager, timeout: 5
    @request.start = Time.now
    @request.end = @request.start.change({hour: 18, min: 0, sec: 0})
    if @request.end < @request.start
      @request.end += 1.day
    end
    @title = I18n.t "request.create"
    render '_form'
  end

  # GET /requests/1/edit
  def edit
    @title = @request.name
    render '_form'
  end

  # POST /requests
  def create
    @request = @project.requests.new(request_params)
    if @request.save
      Rails.logger.info("Request created")
      RequestWorker.perform_at(@request.start, @request.id)
      redirect_to project_request_path(@project, @request), notice: I18n.t("request.created_successfully")
    else
      @title = I18n.t "request.create"
      render '_form'
    end
  end

  # PATCH/PUT /requests/1
  def update
    if @request.update(request_params)
      redirect_to project_requests_path(@project, @request), notice: I18n.t("request.updated_successfully")
    else
      @title = @request.name
      render '_form'
    end
  end

  def accept
    @title = @request.name
    if request_status_ok?
      @request_status.accept
      Rails.logger.info("Request accepted")
      RequestWorker.perform_async(@request.id)
    end
  end

  def decline
    @title = @request.name
    if request_status_ok?
      @request_status.decline
      Rails.logger.info("Request declined")
      RequestWorker.perform_async(@request.id)
    end
  end

  private
  def set_project
    @project = Project.friendly.find(params[:project_id])
    raise ActiveRecord::RecordNotFound if @project.nil?
  end

  def set_request
    id = params[:id] || params[:request_id]
    if @project
      @request = @project.requests.find(id)
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
    params.require(:request).permit(:name, :description, :amount, :start, :end, :timeout, :range, :project_id, :manager_in_charge_id)
  end
end
