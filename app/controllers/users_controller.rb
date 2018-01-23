class UsersController < ApplicationController
  before_action :save_login_state, only: [:new, :create]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.registration_confirmation(@user).deliver
      if params[:remember_me]
        cookies.permanent[:auth_token] = @user.auth_token
      else
        cookies[:auth_token] = @user.auth_token
      end
      flash[:notice] = "You signed up succesfully"
      flash[:color] = "valid"
      redirect_to root_path
    else
      flash[:notice] = "Form is invalid"
      flash[:color] = "invalid"
      redirect_to new_user_path
    end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      flash[:success] = "Welcome to Socialize! Your email has been confirmed. Please sign in to continue."
      redirect_to sessions_login_path
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to root_path
    end
end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password)
  end
end
