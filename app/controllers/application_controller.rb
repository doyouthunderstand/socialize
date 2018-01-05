class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected
  
    def authenticate_user
      if cookies[:auth_token]
        @current_user = User.find_by_auth_token!(cookies[:auth_token])
        return true
      else
        redirect_to sessions_login_path
        return false
      end
    end
  
    def save_login_state
      if session[:user_id]
        redirect_to root_path
        return false
      else
        return true
      end
    end
end
