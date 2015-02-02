class ContactsController < ApplicationController
  before_action :require_localhost, only: :updatedb
  skip_before_action :verify_authenticity_token
  PERMITED_PARAMS = %i{login name extension mobile home company department title address}
  def show
    @contacts = Contact.all
  end
  def updatedb
      Contact.delete_all
    params["_json"].each do |contact|
      Contact.new(contact.permit PERMITED_PARAMS).save
      #c = Contact.find_by_login contact[:login]
      #c ? c.update(contact.permit PERMITED_PARAMS) : Contact.new(contact.permit PERMITED_PARAMS).save
    end
    render :nothing => true
  end

  private

  def require_localhost
    render :nothing => true unless %w{::1 127.0.0.1}.include? request.remote_ip
  end
end