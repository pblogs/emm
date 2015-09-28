FactoryGirl.define do
  factory :video do
    association :album
    preview { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures' , 'images', "#{rand(5..8)}.jpeg")) }
    video_id { Faker::Number.number(10) }
  end

  # trait :with_text
end
