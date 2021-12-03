FactoryBot.define do
  factory :order_item do
    order{association :order}
    product{association :product}
    quantity{1}
  end
end
