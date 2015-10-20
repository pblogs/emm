FactoryGirl.define do
  factory :relationship do
    association :user
    association :friend, factory: :user
  end
end
