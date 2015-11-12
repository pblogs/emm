FactoryGirl.define do
  factory :album do
    association :user
    title { Faker::Lorem.sentence(1, false, 5) }
    description { Faker::Lorem.sentence(3, false, 20) }
    privacy :for_all

    factory :album_with_tags do
      after(:create) do |album|
        friend = create(:user, :confirmed)
        relationship = create(:relationship, sender: album.user, recipient: friend)
        relationship.update(status: 'accepted')
        %i{ video photo text }.each do |content_name|
          create(:tag, target: create(content_name, album: album), author: album.user, user: friend)
        end
        create(:tag, target: album, author: album.user, user: friend)
        album
      end
    end
  end

  trait :with_dates do
    start_date { Faker::Date.between(10.years.ago, Date.today) }
    end_date { Faker::Date.between(start_date, Date.today) }
  end

  trait :private do
    privacy :for_friends
  end

  trait :with_location do
    location_name { "#{Faker::Address.city}, #{Faker::Address.street_address}" }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end

  trait :with_tags do
    after(:create) do |album|
      create_list(:tag, 3, target: album, author: album.user)
    end
  end
end
