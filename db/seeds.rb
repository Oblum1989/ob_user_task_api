User.create!([
  { email: Faker::Internet.email, full_name: Faker::Name.name, role: :admin },
  { email: Faker::Internet.email, full_name: Faker::Name.name, role: :user },
  { email: Faker::Internet.email, full_name: Faker::Name.name, role: :guest }
])
puts "Created #{User.count} users."
