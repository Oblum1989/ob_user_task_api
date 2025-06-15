User.create!([
  { email: Faker::Internet.email, password: 'password123', full_name: Faker::Name.name, role: :admin },
  { email: Faker::Internet.email, password: 'password123', full_name: Faker::Name.name, role: :user },
  { email: Faker::Internet.email, password: 'password123', full_name: Faker::Name.name, role: :guest }
])
puts "Created #{User.count} users."

Task.create!([
  { title: "Complete Rails project", description: "Finish the current Rails project by the end of the week.", status: :pending, due_date: Date.today + 7.days, user_id: User.first.id },
  { title: "Review pull requests", description: "Go through the open pull requests and provide feedback.", status: :completed, due_date: Date.today + 3.days, user_id: User.first.id },
  { title: "Update documentation", description: "Ensure all project documentation is up to date.", status: :expired, due_date: Date.today - 5.days, user_id: User.first.id },
  { title: "Plan next sprint", description: "Prepare for the next sprint planning meeting.", status: :archived, due_date: Date.today + 14.days, user_id: User.second.id },
  { title: "Fix bugs in production", description: "Address critical bugs reported by users.", status: :pending, due_date: Date.today + 2.days, user_id: User.second.id },
  { title: "Implement new feature", description: "Start working on the new feature requested by the client.", status: :pending, due_date: Date.today + 12.days, user_id: User.second.id },
  { title: "Conduct code review", description: "Review the latest code changes submitted by the team.", status: :completed, due_date: Date.today + 1.day, user_id: User.third.id },
  { title: "Conduct user testing", description: "Organize and conduct user testing sessions.", status: :completed, due_date: Date.today + 10.days, user_id: User.third.id },
  { title: "Prepare release notes", description: "Draft release notes for the upcoming version.", status: :pending, due_date: Date.today + 5.days, user_id: User.third.id }
])
puts "Created #{Task.count} tasks."
