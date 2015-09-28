FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birthday { Faker::Date.backward 50.years  }
    email { "user_#{SecureRandom.uuid}@example.com" }
    password 'password'
    password_confirmation 'password'
  end

  trait :with_avatar do
    avatar { File.open(File.join(Rails.root, 'spec', 'fixtures' , 'avatars', "#{rand(1..10)}.jpg")) }
  end

  trait :confirmed do
    confirmed_at Time.now
  end

  trait :admin do
    role :admin
  end
end
