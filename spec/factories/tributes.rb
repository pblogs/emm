FactoryGirl.define do
  factory :tribute do
    association :author, factory: :user
    association :user
    title { Faker::Lorem.sentence(1, false, 5) }
    description { Faker::Lorem.paragraph(1, false, 5) }
  end
end
