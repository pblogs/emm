require 'rails_helper'

RSpec.describe 'Registration', type: :request do
  describe 'POST create' do
    let(:password) { Devise.friendly_token.first(8) }

    before(:each) do
      @data = attributes_for(:user)
    end

    it 'response should be success' do
      post '/api/registration', user: @data

      expect(response).to be_success
    end

    it 'creates new user' do
      expect { post '/api/registration', user: @data }.to change(User, :count).by 1
    end

    it 'should send confirmation email' do
      MandrillMailer.deliveries.clear

      post '/api/registration', user: @data

      email = MandrillMailer::deliveries.find do |mail|
        is_receiver = mail.message['to'].any? { |to| to['email'] == @data[:email] }
        mail.template_name == 'user-confirmation-instructions' && is_receiver
      end

      expect(email).to_not be_nil
    end
  end
end
