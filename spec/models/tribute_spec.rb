require 'rails_helper'

RSpec.describe Tribute, type: :model do
  let(:user) { create(:user, :confirmed) }

  it 'should not create tribute for self' do
    expect{
      Tribute.create(user: user, author: user, description: Faker::Lorem.paragraph )
    }.to change(Tribute, :count).by 0
  end

  it 'should add validation error' do
    tribute = Tribute.create(user: user, author: user, description: Faker::Lorem.paragraph )
    expect(tribute.errors[:user_id].size).to eq(1)
  end
end
