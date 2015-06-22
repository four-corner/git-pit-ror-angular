class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.includes(:user).all
    respond_with(@projects) do |format|
      format.json { render :json => {:list => @projects.as_json, :current_user => current_user.as_json} }
      format.html
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    respond_with(@project) do |format|
      format.json { render json: @project.as_json }
      format.html
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
    respond_with(@project) do |format|
      format.json { render :json => {:project => @project.as_json, :is_admin => current_user.admin?} }
      format.html
    end
  end

  # GET /projects/1/edit
  def edit
    respond_with(@project) do |format|
      format.json { render :json => {:project => @project.as_json, :is_admin => current_user.admin?} }
      format.html
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    begin
      respond_to do |format|
        if @project.save
          format.html { redirect_to @project, notice: 'Project was successfully created.' }
          format.json { render :show, status: :created, location: @project }
        else
          format.html { render :new }
          format.json { render json: @project.errors.full_messages, status: :unprocessable_entity }
        end
      end
    rescue Exception => e
      @project.destroy
      respond_to do |format|
        format.html { render :new }
        format.json { render json: e.as_json, status: :service_unavailable }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    begin
      existing_repo_name = @project.repo_name
      @project.instance_variable_set(:@old_repo_name, existing_repo_name)
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to @project, notice: 'Project was successfully updated.' }
          format.json { render :show, status: :ok, location: @project }
        else
          format.html { render :edit }
          format.json { render json: @project.errors.full_messages, status: :unprocessable_entity }
        end
      end
    rescue Exception => e
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: e.as_json, status: :service_unavailable }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    begin
      github_res = @project.delete_github_repository
      tracker_res = @project.delete_pivotaltracker_project
      if github_res & tracker_res.nil?
        @project.destroy
        respond_to do |format|
          format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to projects_url, alert: 'Project was not destroyed.' }
          format.json { head :no_content }
        end
      end
    rescue Exception => e
      respond_to do |format|
        format.html { redirect_to projects_url, alert: 'Project was not destroyed. Try again', status: :service_unavailable }
        format.json { render json: e.as_json, status: :service_unavailable }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.includes(:user).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:customer, :product, :platform, :user_id)
    end
end
