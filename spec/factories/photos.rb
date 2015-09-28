FactoryGirl.define do
  factory :photo do
    association :album
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures' , 'images', "#{rand(1..10)}.jpeg")) }
  end

  trait :with_text do
    title { Faker::Lorem.sentence(1, false, 5) }
    description { Faker::Lorem.sentence(3, false, 20) }
  end
end
