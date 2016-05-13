# spec/factories/tenant.rb
require 'faker'

FactoryGirl.define do
  factory :tenant do |f|
    f.name { Faker::Name.name }
  #  f.payment_handle { Faker::Lorem.characters(10).upcase }
  #  f.phone_num { Faker::PhoneNumber.cell_phone }
  #  f.email { Faker::Internet.email }
  end
end
