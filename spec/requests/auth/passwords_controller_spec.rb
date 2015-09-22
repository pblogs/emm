require 'rails_helper'

RSpec.describe 'Reset passwords', type: :request do

  before(:each) do
    @user = create :user
    MandrillMailer.deliveries.clear
  end

  describe 'POST create' do
    it 'should be success' do
      post '/api/passwords', { user: { email: @user.email } }

      expect(response).to be_success
    end

    it 'should send email' do
      post '/api/passwords', { user: { email: @user.email } }

      email = MandrillMailer::deliveries.find do |mail|
        is_receiver = mail.message['to'].any? { |to| to['email'] == @user.email }
        mail.template_name == 'reset-password-instructions' && is_receiver
      end

      expect(email).to_not be_nil
    end
  end

  describe 'PUT update' do
    before(:each) do
      @token = @user.send_reset_password_instructions
      @new_password = Devise.friendly_token.first(8)
    end

    it 'should be success' do
      put '/passwords', { user: { password: @new_password, password_confirmation: @new_password,
                                  reset_password_token: @token } }

      expect(response).to be_success
    end

    it 'should change password' do
      put '/api/passwords', { user: { password: @new_password, password_confirmation: @new_password,
                                  reset_password_token: @token } }

      expect(@user.reload).to be_valid_password(@new_password)
    end
  end
end
