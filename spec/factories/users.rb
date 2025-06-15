FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    full_name { Faker::Name.name }
    role { 1 }
    password { 'password123' }
  end
end
