require 'rails_helper'

RSpec.describe MainPageController, type: :controller do
  login_user

  let(:per_page) { 3 }
  let(:types) { %W{photo video text album} }
  let!(:tiles) do
    types.each { |type| create(type).create_tile_on_user_page }
  end

  describe '#index' do
    it 'should response success' do
      get :index
      expect(response).to be_success
    end

    it 'returns correct per page' do
      get :index, per_page: per_page
      expect(json_response['resources'].length).to eq per_page
    end

    it 'returns all tile types' do
      get :index
      expect(json_response['resources'].map { |tile| tile['content_type']}).to include(*types)
    end
  end
end
