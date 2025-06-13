FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    status { 1 }
    due_date { "2025-06-13" }
    user { nil }
  end
end
