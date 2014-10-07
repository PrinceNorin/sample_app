namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
  
  def make_users
    User.create!(name: 'norin',
                 email: 'norin@example.com',
                 password: 'secret',
                 password_confirmation: 'secret',
                 admin: true,
                 activated: true,
                 activated_at: Time.zone.now)
    
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n}@example.com"
      password = 'password'
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   activated: true,
                   activated_at: Time.zone.now)
    end
  end
  
  def make_microposts
    users = User.limit(6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create(content: content) }
    end
  end
  
  def make_relationships
    users = User.all
    user = User.first
    followed_users = users[2..50]
    followers = users[3..40]
    
    followed_users.each do |followed|
      user.follow!(followed)
    end
    
    followers.each do |follower|
      follower.follow!(user)
    end
  end
end