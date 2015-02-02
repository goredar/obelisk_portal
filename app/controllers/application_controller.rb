class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  helper_method :current_user

  def current_user
    session[:user_id]
  end

  def set_locale
    I18n.locale = params[:locale] || "ru"
  end
end