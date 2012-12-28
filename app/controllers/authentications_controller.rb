class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    begin
      omniauth = request.env["omniauth.auth"]
      Rails.logger.debug  "**Omniauth******************* #{omniauth.to_yaml}"
      uid = current_user.try(:id)
      authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      Rails.logger.debug  "**authentication1******************* #{authentication.to_yaml}"

      if authentication && session[:change_avatar]
        if omniauth['credentials']['token']
          authentication.token = omniauth['credentials']['token']
          authentication.save
        end
        Rails.logger.debug  "**authentication2******************* #{authentication.to_yaml}"
        redirect_to "/set_avatar/#{authentication.provider_name.titleize}?image=#{omniauth['info']['image']}"
      elsif authentication
        if omniauth['credentials']['token']
          authentication.token = omniauth['credentials']['token']
          authentication.save
        end
        sign_in_and_redirect(authentication.user)
      elsif current_user
        Rails.logger.debug  "**authentication3******************* #{authentication.to_yaml}"
        current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'] ? omniauth['credentials']['token'] : "" )
        flash[:notice] = "Authentication successful."
        redirect_to edit_user_registration_url(tab:"social_media")
      else
        Rails.logger.debug  "**authentication4******************* #{authentication.to_yaml}"
        user = User.find_by_email(omniauth['info']['email'])
        if user.present?
          Rails.logger.debug  "**authentication5******************* #{authentication.to_yaml}"
          user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'] ? omniauth['credentials']['token'] : "" )
        else
          Rails.logger.debug  "**authentication6******************* #{authentication.to_yaml}"
          user = User.new
          user.set_uuid_pwd
          user.apply_omniauth(omniauth)
        end
        if user.save
          Rails.logger.debug  "**authentication7******************* #{authentication.to_yaml}"
          sign_in_and_redirect(user)
        else
          Rails.logger.debug  "**authentication8******************* #{authentication.to_yaml}"
          flash[:alert] = "Please enter the missing information to complete the registration"
          session[:images_omniauth] = omniauth.except('extra')
          redirect_to new_user_registration_url(:auth => true)
        end
      end
    rescue Exception => ex
      Rails.logger.debug  "**authentication9******************* #{authentication.to_yaml}"
      Rails.logger.debug ex.message
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroy authentications."
    redirect_to edit_user_registration_url(tab:"social_media")
  end

end

