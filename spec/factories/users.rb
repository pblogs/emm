FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { "user_#{SecureRandom.uuid}@example.com" }
    password 'password'
    password_confirmation 'password'
  end

  # trait :with_avatar do
  #   remote_avatar_url { 'http://lorempixel.com/640/480/people' }
  # end

  trait :confirmed do
    confirmed_at Time.now
  end

  trait :admin do
    role :admin
  end
end
