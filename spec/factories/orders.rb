FactoryBot.define do
  factory :order do
    user{association :user}
  end
end
