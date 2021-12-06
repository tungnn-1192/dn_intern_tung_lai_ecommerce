FactoryBot.define do
  factory :user do
    sequence(:email){|x| "seeder.user#{x}@seeder.com"}
    first_name{Faker::Name.first_name}
    last_name{"#{Faker::Name.last_name} #{Faker::Name.last_name}"}
    telephone{user_telephone}
    address{user_address}
    birthday{user_birthday}
    gender{rand < Settings.seeder.digit.male_probability}
    role{:user}
    password{Settings.seeder.password}
    password_confirmation{Settings.seeder.password}
  end
end

private

def user_telephone
  telephone = Faker::PhoneNumber.cell_phone
  while (telephone.length < Settings.length.telephone.min) ||
        (telephone.length > Settings.length.telephone.max)
    telephone = Faker::PhoneNumber.cell_phone
  end
  telephone
end

def user_address
  "#{Faker::Address.street_address}, "\
  "#{Faker::Address.state}, #{Faker::Address.city}"
end

def user_birthday
  Faker::Date.birthday(
    min_age: Settings.seeder.digit.age.min,
    max_age: Settings.seeder.digit.age.max
  )
end
