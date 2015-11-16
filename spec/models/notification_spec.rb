require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:user) { create(:user, :confirmed) }
  let(:another_user) { create(:user, :confirmed) }

  describe 'like' do
    it 'should create notification for like' do
      expect{
        create(:like, target: user.default_album, user: another_user)
      }.to change(Notification.where(event: Notification.events['like']), :count).by 1
    end

    it 'should not create notification for like to own record' do
      expect{
        create(:like, target: user.default_album, user: user)
      }.to change(Notification.where(event: Notification.events['like']), :count).by 0
    end
  end

  describe 'comment' do
    it 'should create notification for comment' do
      expect{
        create(:comment, commentable: user.default_album, author: another_user)
      }.to change(user.notifications.where(event: Notification.events['comment']), :count).by 1
    end

    it 'should not create notification for comment to own record' do
      expect{
        create(:comment, commentable: user.default_album, author: user)
      }.to change(user.notifications.where(event: Notification.events['comment']), :count).by 0
    end
  end

  it 'should create notification for tribute' do
    expect{
      create(:tribute, user: user, author: another_user)
    }.to change(user.notifications.where(event: Notification.events['tribute']), :count).by 1
  end

  it 'should create notification for relationship create' do
    expect{
      create(:relationship, sender: user, recipient: another_user)
    }.to change(another_user.notifications.where(event: Notification.events['relationship']), :count).by 1
  end

  it 'should create notification for relationship accept' do
    expect{
      relationship = create(:relationship, sender: user, recipient: another_user)
      relationship.update(status: 'accepted')
    }.to change(user.notifications.where(event: Notification.events['relationship_accepted']), :count).by 1
  end

  it 'should create notification for relationship decline' do
    expect{
      relationship = create(:relationship, sender: user, recipient: another_user)
      relationship.update(status: 'declined')
    }.to change(user.notifications.where(event: Notification.events['relationship_declined']), :count).by 1
  end

  it 'should create notification for tribute pin' do
    tribute = create(:tribute, user: user, author: another_user)
    expect{
      tribute.create_tile_on_user_page
    }.to change(another_user.notifications.where(event: Notification.events['tribute_pin']), :count).by 1
  end
end
