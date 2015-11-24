require 'factory_girl_rails'

### Helpers

def create_stuff_for_user(user, opts={})
  author = FactoryGirl.create :user, :confirmed
  relationship = FactoryGirl.create :relationship, sender: user, recipient: author
  relationship.update_attribute(:status, 'accepted')

  # Add media to default album
  5.times { create_media_for_album(user.default_album) }
  # Create album with medias
  album = FactoryGirl.create :album, user: user
  5.times { create_media_for_album(album) }
  # Another album with many medias
  if opts[:create_big_album]
    album = FactoryGirl.create :album, :with_dates, :with_location, user: user
    30.times { create_media_for_album(album) }
  end
  5.times do
    tribute = FactoryGirl.create(:tribute, user: user)
    rand(1..10).times do
      FactoryGirl.create(:like, target: tribute)
    end
  end
  Notification.all.sample(10).each { |n| n.update_attribute(:viewed, true ) }
end

def create_media_for_album(album)
  media_type = [:photo, :video, :text].sample
  traits = []
  traits << :with_text if rand > 0.5
  media = FactoryGirl.create media_type, *traits, album: album
  # Sometimes create tile on personal page for media
  if rand > 0.8 && !album.default?
    media.create_tile_on_user_page
  end
end

# Returns random subset of passed array
def rand_array_slice(arr)
  arr.shuffle[0..rand(arr.length)]
end


### Clean DB AND uploads

DatabaseCleaner.strategy = :truncation, { except: %w(public.schema_migrations) }
DatabaseCleaner.clean
FileUtils.rm_rf('public/uploads/.')
puts 'DB and Uploads cleared'


### Create admin

FactoryGirl.create :user, :admin, :confirmed, email: 'admin@example.com', password: 'password', first_name: 'Admin', last_name: 'User'
puts 'Admin created'


### Create example user

user = FactoryGirl.create :user, :confirmed, :with_avatar, email: 'user1@example.com', password: 'password', first_name: 'John', last_name: 'Snow'
create_stuff_for_user(user, create_big_album: true)
puts 'Example user created'


### Create more users

(2..9).each do |i|
  user = FactoryGirl.create :user, :confirmed, :with_avatar, email: "user#{i}@example.com", password: 'password'
  create_stuff_for_user(user)
  puts "User #{i} created"
end
