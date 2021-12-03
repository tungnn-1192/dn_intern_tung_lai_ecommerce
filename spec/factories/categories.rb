FactoryBot.define do
  factory :category do
    sequence(:title){|n| "Category #{n}"}
    parent{nil}
  end
end
