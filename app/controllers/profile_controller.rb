class ProfileController < ApplicationController

  before_filter :match_url

  def show
    @user = User.find_by_slug(params[:slug])
  end

  def match_url
    @user = User.find_by_slug_and_public(params[:slug], 1) || not_found

  end
end
