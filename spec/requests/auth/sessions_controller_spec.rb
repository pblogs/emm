require 'rails_helper'

RSpec.describe 'Session', type: :request do

  before(:each) do
    @password = Devise.friendly_token.first(8)
    @user = build(:user, password: @password, password_confirmation: @password)
    @user.skip_confirmation!
    @user.save
    MandrillMailer.deliveries.clear
  end

  describe 'POST create' do

    it 'should be success' do
      post '/api/login', { user: { email: @user.email, password: @password } }
      expect(response).to be_success
    end

    it 'return user token' do
      post '/api/login', { user: { email: @user.email, password: @password } }
      expect(json_response).to include('auth_token')
    end
  end
end
