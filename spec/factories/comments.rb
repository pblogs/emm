FactoryGirl.define do
  factory :comment do
    association :author, factory: :user
    text { Faker::Lorem.characters(char_count = 100) }

    #default commentable
    association :commentable, factory: :photo

    factory :comment_for_photo do
      association :commentable, factory: :photo
    end

    factory :comment_for_video do
      association :commentable, factory: :video
    end

    factory :comment_for_text do
      association :commentable, factory: :text
    end

    factory :comment_for_album do
      association :commentable, factory: :album
    end

    factory :comment_for_tribute do
      association :commentable, factory: :tribute
    end
  end
end
