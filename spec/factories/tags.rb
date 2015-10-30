FactoryGirl.define do
  factory :tag do
    association :author, factory: :user
    association :user, factory: :user
  end
end
