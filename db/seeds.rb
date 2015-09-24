require 'factory_girl_rails'

### Helpers

def create_stuff_for_user(user, opts={})
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
end

def create_media_for_album(album)
  media_type = [:photo, :video, :text].sample
  traits = []
  traits << :with_text if rand > 0.5
  media = FactoryGirl.create media_type, *traits, album: album
  # Sometimes create tile on personal page for media
  if rand > 0.8 && !album.default?
    media.create_tile_on_user_page [:small, :middle, :large].sample
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

user = FactoryGirl.create :user, :confirmed, email: 'user@example.com', password: 'password', first_name: 'John', last_name: 'Snow'
create_stuff_for_user(user, create_big_album: true)
puts 'Example user created'


### Create more users

10.times do |i|
  user = FactoryGirl.create :user, :confirmed, email: "user#{i+1}@example.com", password: 'password'
  create_stuff_for_user(user)
  puts "User #{i+1} created"
end
