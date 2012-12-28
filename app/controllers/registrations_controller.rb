# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController

  def new
    @user = User.new
    if params[:auth].present? and session[:images_omniauth].present?
      @user.apply_omniauth(session[:images_omniauth])
      @user.valid?
    else
      session[:images_omniauth] = nil
    end
  end

  def create
    @user = User.new(params[:user])
   if session[:images_omniauth].present?
      omniauth = session[:images_omniauth]
      @user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
      @user.set_uuid_pwd
    end

    if @user.save
      flash[:notice] = "Account registered!"
      sign_in_and_redirect(@user)
    else
      render :action => :new
    end
  end

  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end

  def update
    super
  end

end