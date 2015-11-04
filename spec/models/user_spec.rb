require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user) }

  describe 'page alias' do
    it 'should accept small latin letters, digits, dots, dashes and underscores' do
      user.page_alias = 'abc-xyz_01.5.9'
      expect(user).to be_valid
    end

    it 'should not accept other symbols' do
      expect(user.update(page_alias: 'ABCXYZ')).to be_falsey
      expect(user.update(page_alias: 'abcxyz/')).to be_falsey
      expect(user.update(page_alias: 'abcxyz*')).to be_falsey
      expect(user.update(page_alias: 'abcxyz%')).to be_falsey
      expect(user.update(page_alias: 'abcxyz#')).to be_falsey
      expect(user.update(page_alias: 'abcxyz@')).to be_falsey
      expect(user.update(page_alias: 'abcxyz=')).to be_falsey
      expect(user.update(page_alias: 'abc xyz')).to be_falsey
    end
  end

  describe 'relationships' do
    let(:user) { create :user, :with_relations }

    it 'should return correct relationships count' do
      expect(user.relationships.count).to eq (user.incoming_relationships.count + user.outgoing_relationships.count)
    end

    it 'should return correct incoming_friends count' do
      expect(user.incoming_friends.count(:all)).to eq user.incoming_relationships.where(status: Relationship.statuses['pending']).count
    end

    it 'should return correct outgoing_friends count' do
      expect(user.outgoing_friends.count(:all)).to eq user.outgoing_relationships.where(status: Relationship.statuses['pending']).count
    end

    it 'should return correct friends count' do
      friends_count = user.incoming_relationships.where(status: Relationship.statuses['accepted']).count + user.outgoing_relationships.where(status: Relationship.statuses['accepted']).count
      expect(user.friends.count(:all)).to eq friends_count
    end

    describe 'relation_to() and is_friend?()' do
      subject do
        # Accepted
        @friend = create :user
        @friend_relation = create :relationship, sender: user, recipient: @friend, status: 'accepted'
        # Incoming
        @incoming_friend = create :user
        @incoming_relation = create :relationship, sender: @incoming_friend, recipient: user, status: 'pending'
        # Outgoing
        @outgoing_friend = create :user
        @outgoing_relation = create :relationship, sender: user, recipient: @outgoing_friend, status: 'pending'
        # No relation
        @other_user = create :user
      end

      it 'should return correct relation to other user' do
        subject
        relationships = [user.relation_to(@friend.id), user.relation_to(@incoming_friend.id), user.relation_to(@outgoing_friend.id), user.relation_to(@other_user.id)]
        expect(relationships).to eq [@friend_relation, @incoming_relation, @outgoing_relation, nil]
      end

      it 'should return correct status fro is_friend? method' do
        subject
        relationships = [user.is_friend?(@friend.id), user.is_friend?(@incoming_friend.id), user.is_friend?(@outgoing_friend.id), user.is_friend?(@other_user.id)]
        expect(relationships).to eq [true, false, false, false]
      end
    end
  end
end
