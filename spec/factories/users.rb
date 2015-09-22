FactoryGirl.define do
  sequence :user_email do |n|
    "user_#{n}@test.com"
  end

  factory :user do
    first_name 'Ivan'
    last_name 'Ivanov'
    email { generate(:user_email) }
    password 'mypassword111'
    password_confirmation 'mypassword111'
  end
end
