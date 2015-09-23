FactoryGirl.define do
  factory :video do
    association :album
    remote_preview_url { 'http://lorempixel.com/640/480' }
    video_id { Faker::Number.number(10) }
  end

  # trait :with_text
end
