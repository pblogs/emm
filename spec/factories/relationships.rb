FactoryGirl.define do
  factory :relationship do
    association :sender, factory: :user
    association :recipient, factory: :user
  end
end
