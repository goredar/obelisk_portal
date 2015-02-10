class SessionsController < ApplicationController
  def create
    ldap_user = ActiveDirectory::User.find :first, :samaccountname => params[:username]
    if ldap_user && ldap_user.authenticate(params[:password])
      session[:user_id] = ldap_user.samaccountname.force_encoding("UTF-8")
      session[:user_name] = ldap_user.displayname.force_encoding("UTF-8")
      session[:admin] = ldap_user.admin?
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