FactoryGirl.define do
  factory :user do
    name 'norin'
    email 'norin@example.com'
    password 'secret'
    password_confirmation 'secret'
  end
end