FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password 'secret'
    password_confirmation 'secret'
    activated true
    activated_at Time.zone.now
    
    factory(:admin) { admin true }
  end
  
  factory :micropost do
    content 'Lorem ipsum'
    association :user
  end
end