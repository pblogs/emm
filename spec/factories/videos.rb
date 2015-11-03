FactoryGirl.define do
  factory :video do
    association :album
    preview { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures' , 'images', "#{rand(1..10)}.jpeg")) }
    video_id { %w{141096527 140754594 46094631}.sample }
    duration { 60 }
    source :vimeo
  end

  # trait :with_text
  # trait :with_tags
end
