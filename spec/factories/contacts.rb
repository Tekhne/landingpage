FactoryBot.define do
  factory :contact do
    sequence(:email) { |n| "jsmith#{n}@example.com" }
    normalized_email { email }
  end
end
