FactoryGirl.define do
  factory :tribute do
    association :author, factory: :user
    association :user
    description { Faker::Lorem.paragraph(1, false, 5) }
  end
end
