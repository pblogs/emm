require 'rails_helper'

RSpec.describe VideosInformationController, type: :controller do
  login_user

  let(:youtube) { 'https://www.youtube.com/watch?v=e5jDspIC4hY' }
  let(:vimeo) { 'https://vimeo.com/124858722' }

  describe '#show' do
    it 'should response success' do
      get :show, url: vimeo, user_token: @user_token
      expect(response).to be_success
    end

    it 'should respond with video data' do
      [vimeo, youtube].each do |url|
        get :show, url: url, user_token: @user_token
        video = VideoInformation.new(url).parse
        expect(json_response['resource'].keys).to contain_exactly(*serialized(video).keys)
      end
    end
  end
end
