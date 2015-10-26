require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user) { create(:user, :with_relations, :confirmed) }

  it 'should add validation error on self relation' do
    relation = user.outgoing_relationships.create(recipient: user)
    expect(relation).not_to be_valid
  end

  it 'should add validation error for when relation between same users already exists' do
    another_user = create(:user)
    user.outgoing_relationships.create(recipient: another_user)
    inverse_relation = another_user.outgoing_relationships.create(recipient: user)
    expect(inverse_relation).not_to be_valid
  end
end
