class SessionsController < ApplicationController
  def create
    if user = Contact.auth(params[:username], params[:password])
      session[:user_id] = user.id
      session[:user_login] = user.login
      session[:user_name] = user.name
      session[:user_role] = user.role
      flash[:success] = t("login_success")
    else
      flash[:alert] = t("login_error")
    end
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    session[:user_name] = nil
    session[:user_role] = nil
    flash[:info] = t("logout")
    redirect_to root_path
  end
end