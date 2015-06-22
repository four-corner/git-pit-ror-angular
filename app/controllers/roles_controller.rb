class RolesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :authorize_admin
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  # GET /roles
  # GET /roles.json
  def index
    @roles = Role.all
    respond_with(@roles) do |format|
      format.json { render :json => {:list => @roles.as_json, :current_user => current_user.as_json} }
      format.html
    end
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
    respond_with(@role) do |format|
      format.json { render json: @role.as_json }
      format.html
    end
  end

  # GET /roles/new
  def new
    @role = Role.new
    respond_with(@role) do |format|
      format.json { render :json => {:role => @role.as_json, :is_admin => current_user.admin?} }
      format.html
    end
  end

  # GET /roles/1/edit
  def edit
    respond_with(@role) do |format|
      format.json { render :json => {:role => @role.as_json, :is_admin => current_user.admin?} }
      format.html
    end
  end

  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to @role, notice: 'Role was successfully created.' }
        format.json { render :show, status: :created, location: @role.as_json }
      else
        format.html { render :new }
        format.json { render json: @role.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to @role, notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @role.as_json }
      else
        format.html { render :edit }
        format.json { render json: @role.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name, :description)
    end
end
