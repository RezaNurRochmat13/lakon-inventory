FactoryBot.define do
  factory :transaction do
    product_id { Faker::Number.number(digits: 2) }
    quantity { Faker::Number.number(digits: 2) }
  end
end
