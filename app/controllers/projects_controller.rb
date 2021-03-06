# coding: utf-8
class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update]
  authorize_resource

  # GET /projects
  def public
    @projects = Project.where is_public: true
    @title = I18n.t "project.all_title"
  end

  # GET /projects/1
  def show
    @project = Project.friendly.find params[:id]
    @title = I18n.t "project.manage", project: @project.name
  end


  # GET /projects/new
  def new
    @manager = Manager.new
    @manager.project = Project.new
    @manager.project.is_public = true
    @title = I18n.t "project.new_title"
  end

  # GET /projects/1/edit
  def edit
    @title = I18n.t "project.edit"
    render "_form"
  end

  # POST /projects
  def create
    @title = I18n.t "project.new_title"
    @manager = Manager.new params[:project][:manager].permit(:email, :password, :password_confirmation)
    @manager.project = Project.new(project_params)
    if @manager.save
      redirect_to root_path, flash: {success:  I18n.t("project.created")}
    else
      @manager.project.validate
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    @title = @project.name
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render "_form"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name, :is_public, :description)
    end
end
