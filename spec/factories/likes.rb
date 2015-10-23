FactoryGirl.define do
  factory :like do
    association :user
    association :target, factory: :tribute

    factory :like_for_photo do
      association :target, factory: :photo
    end

    factory :like_for_video do
      association :target, factory: :video
    end

    factory :like_for_text do
      association :target, factory: :text
    end

    factory :like_for_album do
      association :target, factory: :album
    end

    factory :like_for_tribute do
      association :target, factory: :tribute
    end
  end
end
