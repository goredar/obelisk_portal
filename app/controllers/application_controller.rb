class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  I18n.default_locale = :ru

  protect_from_forgery with: :exception
  before_action :set_locale

  helper_method :current_user

  def current_user
    session[:user_id]
  end

  private

  def set_locale
    begin
      I18n.locale = cookies[:locale] || I18n.default_locale
    rescue
      I18n.locale = I18n.default_locale
    end
  end

end