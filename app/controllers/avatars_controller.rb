class AvatarsController < ApplicationController
  def change
    case params[:provider]
      when 'gravatar'
        current_user.avatar.delete if current_user.avatar.present?
        redirect_to 'http://en.gravatar.com/'
      else
        session[:change_avatar] = true
        redirect_to "/auth/#{params[:provider]}"
    end

  end

  def set_avatar
    img = params[:image]
    session[:change_avatar] = nil

    if img.present?
      #pull user avatar
      avatar = current_user.avatar || Avatar.new(:user => current_user)
      avatar.image_url = img
      avatar.save
    else
      flash[:alert] = "No profile image found with #{params[:provider_name]} account"
    end
    redirect_to  :back, :remote => true
  end

end
