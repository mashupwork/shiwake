class WelcomeController < ApplicationController
  before_action :authenticate_user!, except: %i(index)

  def index
    redirect_to :dashboard if user_signed_in? && !Rails.env.development?
  end

  def dashboard
  end
end
