class SessionsController < ApplicationController
    before_action :save_login_state, :only => [:login, :login_attempt]
    def login
    end
  
    def login_attempt
       authorized_user = User.authenticate(params[:email], params[:login_password])
      if authorized_user
        if authorized_user.email_confirmed
          if params[:remember_me]
            cookies.permanent[:auth_token] = authorized_user.auth_token
          else
            cookies[:auth_token] = authorized_user.auth_token
          end
          flash[:notice] = "Successfully logged in."
          redirect_to root_path
        else
          flash.now[:error] = 'Please activate your account by following the instructions in the account confirmation email you received to proceed'
          redirect_to sessions_login_path
        end
      else
        flash[:notice] = "Invalid Username or Password"
        flash[:color]= "invalid"
        redirect_to sessions_login_path
      end
    end
  
    def destroy
      cookies.delete(:auth_token)
      redirect_to root_path, flash[:notice] => "Logged Out"
    end
end
