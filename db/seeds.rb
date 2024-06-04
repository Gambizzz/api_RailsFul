require 'faker'

User.destroy_all
Article.destroy_all

10.times do
  user = User.create!(
    email: Faker::Internet.email,
    password: Faker::Internet.password(min_length: 6)
  )
end
users = User.all

puts "Users ok"

users.each do |user|
  10.times do
    user.articles.create!(
      title: Faker::Dessert.flavor,
      content: Faker::GreekPhilosophers.quote,
      private: [true, false].sample
    )
  end
end

puts "Articles ok"


