FactoryGirl.define do
  factory :photo do
    association :album
    remote_image_url { 'http://lorempixel.com/640/480' }
  end

  trait :with_text do
    title { Faker::Lorem.sentence(1, false, 5) }
    description { Faker::Lorem.sentence(3, false, 20) }
  end
end
