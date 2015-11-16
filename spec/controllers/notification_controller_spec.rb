require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  login_user

  let(:per_page) { 3 }
  let!(:notifications) do
    another_user = create(:user, :confirmed)
    relationship = create(:relationship, sender: @user, recipient: another_user)
    relationship.update(status: 'accepted')
    create(:tag, author: another_user, target: @user.default_album, user: @user)
    create(:like, target: @user.default_album, user: another_user)
    @user.notifications
  end

  describe '#index' do
    subject { get :index, user_token: @user_token, per_page: per_page}
    it 'should response success' do
      subject
      expect(response).to be_success
    end

    it 'returns correct per page' do
      subject
      expect(json_response['resources'].length).to eq per_page
    end

    it 'should be forbidden' do
      get :index
      expect(response).to be_forbidden
    end
  end

  describe '#update' do
    subject { put :update, id: notifications.first.id, resource: { viewed: true }, user_token: @user_token }
    it 'response should be success' do
      subject
      expect(response).to be_success
    end

    it 'should change value' do
      subject
      expect(json_response['resource']['viewed']).to be_truthy
    end

    it 'should raise error' do
      put :update, id: notifications.first.id, resource: { viewed: false }, user_token: @user_token
      expect(json_response['errors']['viewed'].count).to eq(1)
    end

    it 'should be forbidden' do
      put :update, id: notifications.first.id, resource: { viewed: false }
      expect(response).to be_forbidden
    end
  end

  describe '#mass_update' do
    subject { put :mass_update, user_token: @user_token }

    it 'should do mass update' do
      subject
      expect(response).to be_success
    end

    it 'should update notifications' do
      expect {
        subject
      }.to change(@user.notifications.not_viewed, :count).to 0
    end

    it 'should refresh unread_notifications_count' do
      subject
      expect(@user.unread_notifications_count).to eq(0)
    end
  end

  describe '#unread_count' do
    subject { get :unread_count, user_token: @user_token }

    it 'response should be success' do
      subject
      expect(response).to be_success
    end

    it 'should return valid value' do
      subject
      expect(json_response['new_notifications']).to eq(@user.notifications.not_viewed.count)
    end
  end
end
