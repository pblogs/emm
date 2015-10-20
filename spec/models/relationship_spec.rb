require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user) { create(:user, :with_relations, :confirmed) }

  it 'should add validation error on status changing' do
    %W{ accepted declined }.each do |status|
      relation = user.relations.first
      relation.update(status: status)
      expect(relation.errors[:status].size).to eq(1)
    end
  end

  it 'should change status' do
    relation = user.incoming_requests.first
    relation.update(status: 'accepted')
    expect(relation.status).to be_eql('accepted')
  end

  it 'should add validation error on self relation' do
    relation = user.relationships.create(friend: user)
    expect(relation.errors[:friend].size).to eq(1)
  end
end
