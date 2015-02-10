class ContactsController < ApplicationController

  VIEWS = %w{table_view tile_view}

  def show
    @views = VIEWS
    @call_available = [:extension]
    @current_view = @views.include?(cookies[:contacts_view]) ? cookies[:contacts_view] : @views.last
    @contacts = Contact.all.map{ |c| c.name = c.name.split.reverse.join(' '); c}.sort_by(&:name)
  end

end