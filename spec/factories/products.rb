FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    stock { Faker::Number.number(digits: 2) }
  end
end
