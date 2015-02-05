class CookiesController < ApplicationController
  def set
    cookies[params["name"].to_sym] = params["value"]
    redirect_to root_path
  end
end