class SessionsController < ApplicationController
  def create
    ldap_user = Adauth.authenticate(params[:username], params[:password])
    if ldap_user
      session[:user_id] = ldap_user.login
      contact = Contact.find_by_login(session[:user_id])
      session[:user_name] = contact ? contact.name : ldap_user.name
      flash[:success] = t("login_success")
    else
      flash[:alert] = t("login_error")
    end
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = t("logout")
    redirect_to root_path
  end
end