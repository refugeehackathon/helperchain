# coding: utf-8
class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update]
  authorize_resource

  # GET /projects
  def charities
    @projects = Project.where charity: true
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
    @manager.project.charity = false
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
    begin
      ActiveRecord::Base.transaction do
        if @manager.save
          sign_in @manager
          redirect_to @project, notice: 'Project was successfully created.'
        else
          @manager.project.validate
          throw "error"
        end
      end
    rescue
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
      params.require(:project).permit(:name, :charity, :description)
    end
end
