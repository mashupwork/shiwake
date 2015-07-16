class SessionsController < ApplicationController
  before_action :authenticate_user!, except: %i(create failure)

  def create
    auth_hash = request.env['omniauth.auth']
    self.current_user = auth_hash
    redirect_to :dashboard, notice: 'Signed in successfully'
  end

  def destroy
    self.current_user = nil
    redirect_to :root, notice: 'Signed out successfully'
  end

  def failure
    redirect_to :root, alert: 'Sign in failed'
  end
end
