require 'rails_helper'

RSpec.describe Page, type: :model do

  let(:user) { create(:user) }

  describe 'default page' do
    it 'should be auto created with user' do
      expect(user.pages.first.default?).to be_truthy
    end

    it 'should be only 1 per user' do
      expect(user.pages.build(default: true)).to be_invalid
    end

    it 'should not be destroyable' do
      expect(user.default_page.destroy).to be_falsey
    end

    it 'should be destroyed when user is destroying' do
      user.reload
      expect { user.destroy }.to change { user.pages.count }.by(-1)
    end
  end

  describe 'ordering' do
    let!(:another_user) { create(:user) }

    before :each do
      # Creating pages for other user (just to add some other data)
      2.times { another_user.pages.create }
      # Creating tiles for tested user
      3.times { user.pages.create }
    end

    it 'should be created with incremented weight (within user)' do
      top_page_weight = user.pages.last.weight
      expect(user.pages.create.weight).to be_eql top_page_weight+1
    end

    it 'should be ordered from top weight to last' do
      expect(user.pages.pluck(:weight)).to be_eql [0, 1, 2, 3]
    end
  end
end
