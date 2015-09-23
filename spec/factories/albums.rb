FactoryGirl.define do
  factory :album do
    association :user
    title { Faker::Lorem.sentence(1, false, 5) }
    description { Faker::Lorem.sentence(3, false, 20) }
  end

  trait :default do
    default true
  end

  trait :with_dates do
    start_date { Faker::Date.between(10.years.ago, Date.today) }
    end_date { Faker::Date.between(start_date, Date.today) }
  end

  trait :with_location do
    location_name { "#{Faker::Address.city}, #{Faker::Address.street_address}" }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
