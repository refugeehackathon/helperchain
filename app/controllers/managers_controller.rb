class ManagersController < ApplicationController
  before_action :set_project
  before_action :set_manager, except: [:new, :create]
  authorize_resource

  def show
    @title = @manager.display_name
    @requests = @manager.requests
  end

  def new
    @title = I18n.t "manager.create"
    @manager = @project.managers.new
    @manager.is_admin = false
    render "_form"
  end

  def edit
    @title = I18n.t "manager.edit", manager: @manager.display_name
    render "_form"
  end

  def create
    @manager = @project.managers.new manager_params
    @manager.confirmed_at = Time.now
    if @manager.save
      redirect_to project_path(@project), flash: {success: I18n.t("manager.create_success", manager: @manager.display_name)}
    else
      @title = I18n.t "manager.create"
      render "_form"
    end
  end

  def update
    mparams = manager_params
    if mparams[:password].empty? && mparams[:password_confirmation].empty?
      mparams.delete :password
      mparams.delete :password_confirmation
    end
    if @manager.update(mparams)
      redirect_to project_path(@project), flash: {success: I18n.t("manager.edit_success", manager: @manager.display_name)}
    else
      @title = I18n.t "manager.edit", manager: @manager.display_name
      render "_form"
    end
  end

  def destroy
    if @manager.is_admin && @project.admins.count == 1
      redirect_to project_path(@project), flash: {danger: I18n.t("manager.cannot_delete_last_admin", manager: @manager.display_name)}
    else
      @manager.destroy
      redirect_to project_path(@project), flash: {success: I18n.t("manager.destroy_success", manager: @manager.display_name)}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.friendly.find(params[:project_id])
  end

  def set_manager
    @manager = @project.managers.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def manager_params
    params.require(:manager).permit(:email, :is_admin, :name, :password, :password_confirmation)
  end
end
