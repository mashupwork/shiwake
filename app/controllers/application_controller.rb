class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
    def current_user
      if session[:user].present?
        @current_user ||= OmniAuth::AuthHash.new(session[:user])
      end
    end
    helper_method :current_user

    def user_signed_in?
      !!current_user
    end
    helper_method :user_signed_in?

    def current_user=(user)
      @current_user = user
      session[:user] = user
    end

    def authenticate_user!
      redirect_to :root, alert: 'Signed in' unless user_signed_in?
    end

    def client
      token = TimeCrowd.new(current_user.credentials)

      current_user.credentials.expires_at = token.access_token.expires_at
      current_user.credentials.refresh_token = token.access_token.refresh_token
      current_user.credentials.token = token.access_token.token
      self.current_user = current_user

      token
    end
end
