class ContactsController < ApplicationController

  before_action :require_localhost, only: :updatedb
  skip_before_action :verify_authenticity_token

  PERMITED_PARAMS = %i{login name extension mobile home company department title address}
  VIEWS = %w{table_view tile_view}

  def show
    @views = ContactsController::VIEWS
    @call_available = [:extension]
    @current_view = @views.include?(cookies[:contacts_view]) ? cookies[:contacts_view] : @views.last
    @contacts = Contact.all.sort_by { |i| i.name.split[1] }
  end

  def updatedb
      Contact.delete_all
      p params
    params["_json"].each do |contact| 
      Contact.new(contact.permit PERMITED_PARAMS).save
      #c = Contact.find_by_login contact[:login]
      #c ? c.update(contact.permit PERMITED_PARAMS) : Contact.new(contact.permit PERMITED_PARAMS).save
    end if params["_json"]
    render :nothing => true
  end

  private

  def require_localhost
    render :nothing => true unless %w{::1 127.0.0.1}.include? request.remote_ip
  end

end