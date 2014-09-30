namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: 'norin',
                 email: 'norin.hor@gmail.com',
                 password: 'secret',
                 password_confirmation: 'secret',
                 admin: true)
    
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n}@example.com"
      password = 'password'
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end