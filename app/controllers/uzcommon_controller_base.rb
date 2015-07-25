# -*- encoding : utf-8 -*-
class UzcommonControllerBase < ActionController::Base
  helper BsAdmin::SettingsHelper
  helper Uzcommon::AllHelpers  

  protect_from_forgery with: :exception
  after_filter :set_csrf_cookie_for_ng
  before_filter :prepare_for_mobile

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  protected

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  def login_redirect_path
    if session[:current_logged_path]
      session[:current_logged_path]
    else
      logged_path
    end
  end

  def validate_params required
    not_satisfied = []
    required.each do |r|
      not_satisfied << r if params.keys.include?(r) or [nil, ""].include?(params[r])
    end
    
    raise CustomExceptions::ParamsNotSatisfied.new(not_satisfied) if not_satisfied.any?    
  end

  def normalize_params_values input=nil
    is_root = false    
    if input == nil
      input = params
      is_root = true
    end    

    input.each do |key, value|      
      if value == nil
        input[key] = nil
      elsif value.is_a?(Hash) 
        input[key] = normalize_params_values value 
      elsif value.is_a?(String)
        if value.strip == ""
          input[key] = nil
        elsif %w(true on).include? value
          input[key] = true 
        elsif %w(false off).include? value
          input[key] = false 
        elsif %w(null nil).include? value
          input[key] = nil 
        elsif value.is_integer?
          input[key] = value.to_i
        elsif value.is_number?
          input[key] = Float(value)  
        else
          input[key] = value
        end
      else
        input[key] = value
      end
    end
    
    input.each { |key, value| params[key] = value } if is_root    

    input
  end

  public  

  rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound do |exception|
    render_error :not_found, exception
  end

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
    render_error :unauthorized, 'Invalid authenticity token'
  end

  rescue_from CustomExceptions::WrongToken do |exception|
    render json: { errors: { exception.token_name => 'Wrong token' } }, status: :bad_request
  end

  rescue_from CustomExceptions::ParamsNotSatisfied do |exception|    
    errors = {}
    exception.params.each { |p| errors[p] = "Input param not satisfied" }

    render json: { errors: errors }, status: :bad_request
  end

  rescue_from CustomExceptions::InvalidModelState do |exception|
    render json: { message: exception.message }, status: :unprocessable_entity
  end

  rescue_from CustomExceptions::ModelNotValid do |exception|
    render json: { errors: exception.errors }, status: :unprocessable_entity
  end

  rescue_from CustomExceptions::InvalidParams do |exception|
    errors = {}
    exception.params.each { |p| errors[p] = "Invalid value" }
    
    render json: { errors: errors }, status: :unprocessable_entity    
  end

  rescue_from CustomExceptions::EntityNotFound do |exception|
    render json: { message: "Entity #{exception.entity} with id: #{exception.id} not found" }, status: :not_found
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception do |exception|
      render_error :internal_server_error, exception
    end
  end

  protected

  def json_success message
    render json: { message: message }
  end

  def json_error_message message, *params
    params[:message] = message
    json_error params
  end

  def json_error *params
    result = {}
    result[:errors] = {}

    params.each do |k, v|
      if k == :message
        result[:message] = v
      elsif v.is_a? Array
        result[:errors][k] = v
      else
        result[:errors][k] = [v]
      end
    end

    render json: result, status: :unprocessable_entity
  end

  private

  def render_error status, message
    @error_code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
    message = Rack::Utils::HTTP_STATUS_CODES[@error_code] if message == nil
    @error_message = message

    respond_to do |format|
      format.html { render template: "errors/error", layout: false, status: status }
      format.json { render json: { message: message }, status: status }
      format.all { render nothing: true, status: status }
    end
  end  

  def admin?
    session[:password] == ENV["ADMIN_PASSWORD"]
  end
  helper_method :admin?

  def mobile_device?
    session[:mobile_param] and session[:mobile_param] == "1"
  end
  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device? and !request.env['PATH_INFO'].starts_with?('/admin')
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
