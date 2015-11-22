# coding: utf-8
class ProjectsController < ApplicationController
  load_resource except: [:show]
  authorize_resource
  before_action :set_project, only: [:show, :edit, :update]

  # GET /projects
  def charities
    @projects = Project.where charity: true
    @title = I18n.t "project.all_title"
  end

  # GET /projects/1
  def show
    @charity = Project.friendly.find params[:id]
    @title = I18n.t "project.manage"
  end


  # GET /projects/new
  def new
    @project = Project.new
    @project.charity = false
    @manager = Manager.new
    @title = I18n.t "project.new_title"
  end

  # GET /projects/1/edit
  def edit
    @title = I18n.t "project.edit"
  end

  # POST /projects
  def create
    @title = I18n.t "project.new_title"
    @project = Project.new(project_params)
    @manager = Manager.new params[:project][:manager].permit(:email, :password, :password_confirmation)
    begin
      ActiveRecord::Base.transaction do
        if @project.save
          @manager.project = @project
          if @manager.save
            sign_in @manager
            redirect_to @project, notice: 'Project was successfully created.'
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

  # PATCH/PUT /projects/1
  def update
    @title = @project.name
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name, :charity)
    end
end
