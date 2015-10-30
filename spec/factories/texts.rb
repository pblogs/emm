FactoryGirl.define do
  factory :text do
    association :album
    title { Faker::Lorem.sentence(1, false, 5) }
    description { Faker::Lorem.sentence(3, false, 20) }
  end

  # trait :with_tags
end
