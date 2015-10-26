require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  login_user

  let(:author) { create(:user, :confirmed) }
  %i{ photo video text tribute comment}.each do |target_name|
    let(:target) { create(target_name) }
    describe '#create' do
      it 'should response success' do
        post :create, user_token: @user_token, resource: { type: target.class.name.underscore, id: target.id }
        expect(response).to be_success
      end

      it 'should create like' do
        expect {
          post :create, user_token: @user_token, resource: { type: target.class.name.underscore, id: target.id }
        }.to change(Like, :count).by 1
      end

      it 'should update counter' do
        expect {
          post :create, user_token: @user_token, resource: { type: target.class.name.underscore, id: target.id }
          target.reload
        }.to change(target, :likes_count).by 1
      end

      it 'should not create like object that not allowed' do
        expect {
          post :create, user_token: @user_token, resource: { type: @user.class.name.underscore, id: target.id }
        }.to raise_error(ParamError::NotAcceptableValue)
      end
    end

    describe '#destroy' do
      let!(:like) { create(:like, user: author) }
      let(:another_user) { create(:user, :confirmed) }

      it 'returns http success' do
        delete :destroy, id: like.id, user_token: author.jwt_token
        expect(response).to be_success
      end

      it 'access denied' do
        delete :destroy, id: like.id
        expect(response).to be_forbidden
      end
    end
  end
end
