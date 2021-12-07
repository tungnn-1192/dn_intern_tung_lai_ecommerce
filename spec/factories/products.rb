FactoryBot.define do
  factory :product do
    name{Faker::Commerce.product_name}
    description{product_description}
    price{product_price}
    rating{product_rating}
    inventory{product_inventory}
    unit{Settings.seeder.unit}
    category{create(:category)}

    trait :with_parent_category do
      transient do
        parent_cat{nil}
      end

      after(:create) do |product, evaluator|
        product.category.parent = evaluator.parent_cat
        product.category.save
      end
    end
  end
end

private

def product_description
  Faker::Lorem.paragraphs(
    number: Settings.seeder.description_paragraphs
  ).join(". ")
end

def product_price
  Faker::Number.number(digits: Settings.seeder.digit.price)
end

def product_rating
  Faker::Number.between(
    from: Settings.seeder.digit.rating.min,
    to: Settings.seeder.digit.rating.max
  )
end

def product_inventory
  Faker::Number.between(
    from: Settings.seeder.digit.inventory.min,
    to: Settings.seeder.digit.inventory.max
  )
end
