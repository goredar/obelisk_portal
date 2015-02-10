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
    (redirect_to root_path and return) unless session[:user_id]
    @contact = Contact.find params[:id]
    @user = (params[:id] == session[:user_id]) ? @contact : Contact.find(session[:user_id])
    if @user.role == "user" && params[:id] != session[:user_id]
      flash[:alert] = t("only_self")
      redirect_to root_path and return
    end
    if params[:contact_photo]
      photo = MiniMagick::Image.read params[:contact_photo].read
      photo.resize "90x90"
      photo.format "png"
      photo.write Rails.root.join("public/images/photo_#{@contact.id}.png")
      File.chmod 0644, Rails.root.join("public/images/photo_#{@contact.id}.png")
      params[:contact][:photo] = "photo_#{@contact.id}.png"
    end
    if @contact.update params[:contact].select{ |k,v| @user.allowed? k }.permit!
      flash[:success] = t("contact_update_done")
    else
      flash[:alert] = t("contact_update_failed")
    end
    redirect_to root_path
  end

  def show_edit_form
    (redirect_to root_path and return) unless session[:user_id]
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