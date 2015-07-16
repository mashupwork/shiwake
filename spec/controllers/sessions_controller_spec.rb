require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#create' do
    before do
      request.env['omniauth.auth'] = auth_hash
      get :create, auth_hash
    end
    it 'sets current_user' do
      expect(session[:user]).to_not eq(nil)
    end
    it 'redirects to dashboard' do
      expect(response).to redirect_to(dashboard_path)
    end
  end

  describe '#destory' do
    before do
      delete :destroy, nil, user: auth_hash
    end
    it 'sets nil to current_user' do
      expect(session[:user]).to eq(nil)
    end
    it 'redirects to root' do
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#failure' do
    before do
      get :failure
    end
    it 'redirects to root' do
      expect(response).to redirect_to(root_path)
    end
  end
end
