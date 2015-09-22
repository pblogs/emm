require 'rails_helper'

RSpec.describe 'Confirmation', type: :request do

  before(:each) do
    @user = create(:user, confirmed_at: nil)
    MandrillMailer.deliveries.clear
  end

  describe 'GET show' do
    it 'should be success' do
      token = @user.instance_variable_get(:@raw_confirmation_token)
      get '/api/confirmation', confirmation_token: token

      expect(response).to be_success
    end

    it 'should confirm user' do
      token = @user.instance_variable_get(:@raw_confirmation_token)
      get '/api/confirmation', confirmation_token: token

      expect(@user.reload).to be_confirmed
    end
  end

  describe 'POST create' do
    it 'should be success' do
      post '/api/resend_confirmation', user: { email: @user.email }

      expect(response).to be_success
    end

    it 'should send confirmation email' do
      MandrillMailer.deliveries.clear
      post '/api/resend_confirmation', user: { email: @user.email }

      email = MandrillMailer::deliveries.find do |mail|
        is_receiver = mail.message['to'].any? { |to| to['email'] == @user.email }
        mail.template_name == 'user-confirmation-instructions' && is_receiver
      end

      expect(email).to_not be_nil
    end
  end
end
