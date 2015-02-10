class ContactsController < ApplicationController
  before_action :require_login, only: [:update, :show_edit_form]

  VIEWS = %w{table_view tile_view}

  def show
    @views = VIEWS
    @call_available = [:extension]
    @current_view = @views.include?(cookies[:contacts_view]) ? cookies[:contacts_view] : @views.last
    @contacts = Contact.all.map{ |c| c.name = c.name.split.reverse.join(' '); c}.sort_by(&:name)
  end

  def update
    if session[:user_role] == "user" && params[:id].to_i != session[:user_id]
      flash[:alert] = t("only_self")
      redirect_to root_path and return
    end
    @contact = Contact.find params[:id]
    @user = Contact.find session[:user_id]
    attrs_to_update = params[:contact] ? params[:contact].select{ |k,v| @user.allowed? k } : {}
    attrs_to_update.select! do |k,v|
      current_v = @contact.public_send(k)
      current_v != v && !(current_v.nil? && v.empty?)
    end
    if @contact.save_photo(params[:contact_photo], params[:delete_contact_photo]) \
        && (attrs_to_update ? @contact.update(attrs_to_update.permit!) : true) \
        && @contact.update_user_in_ldap(attrs_to_update)
      flash[:success] = t("contact_update_done")
    else
      flash[:alert] = t("contact_update_failed")
    end
    redirect_to root_path
  end

  def show_edit_form
    @contact = Contact.find params[:id]
    @user = (params[:id] == session[:user_id]) ? @contact : Contact.find(session[:user_id])
    respond_to do |format|
      format.json
      format.html
    end
  end

  private

  def require_login
    (flash[:alert] = t("require_login"); redirect_to(root_path)) unless session[:user_id]
  end
end