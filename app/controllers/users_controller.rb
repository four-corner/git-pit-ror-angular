class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  skip_authorize_resource :only => [:show, :edit, :index, :update]
  before_action :authorize_admin, only: [:create, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.includes(:role).all
    respond_with(@users) do |format|
      format.json { render :json => {:list => @users.as_json, :current_user => current_user.as_json} }
      format.html
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_with(@user) do |format|
      format.json { render :json => {:user => @user.as_json, :current_user => current_user.as_json} }
      format.html
    end
  end

  # GET /users/new
  def new
    @user = User.new
    @minimum_password_length = 8
    #roles = Role.all
    respond_with(@user) do |format|
      format.json { render :json => {:user => @user.as_json, :is_admin => current_user.admin?, :roles => role_names} }
      format.html
    end
  end

  # GET /users/1/edit
  def edit
    #roles = Role.all
    respond_with(@user) do |format|
      format.json { render :json => {:user => @user.as_json, :is_admin => current_user.admin?, :current_user => current_user, :roles => role_names} }
      format.html
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user.as_json, notice: 'User was successfully created.' }
        @user.send_reset_password_instructions
      else
        format.html { render :new }
        format.json { render json: @user.errors.full_messages, status: :unprocessable_entity  }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user.as_json, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @user.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user.admin?
      respond_to do |format|
        format.html { redirect_to users_url, alert: 'Admin can not be deleted.' }
        format.json { head :no_content }
      end
    else
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.includes(:role).find(params[:id])
    render json: {status: :not_found} unless @user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role_id)
  end
end
