class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied!"
    #redirect_to root_url
    render :json => {error: "Access denied!"}
  end

  respond_to :html, :json

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :role_names, if: :devise_controller?
  helper_method :role_names
  after_action :set_csrf_cookie_for_ng

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  protected

  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end

  # permit non devise parameters
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name, :role_id]
    devise_parameter_sanitizer.for(:account_update) << [:first_name, :last_name, :role_id]
  end

  def role_names
    Role.all.map { |role| {name: role.name, id: role.id} }
  end

  def authorize_admin
    return if current_user.admin?
    redirect_to root_path, alert: 'Admins only!'
  end

end
