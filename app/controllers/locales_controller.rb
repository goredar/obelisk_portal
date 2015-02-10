class LocalesController < ApplicationController
  def set
    cookies[:locale] = params["value"]
    redirect_to root_path
  end
end