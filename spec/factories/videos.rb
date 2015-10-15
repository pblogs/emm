FactoryGirl.define do
  factory :video do
    association :album
    preview { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures' , 'images', "#{rand(1..10)}.jpeg")) }
    video_id { Faker::Number.number(10) }
    source :youtube
  end

  # trait :with_text
end
