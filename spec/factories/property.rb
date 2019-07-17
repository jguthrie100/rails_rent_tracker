# spec/factories/property.rb
require 'faker'

FactoryBot.define do
  factory :property do |f|
    f.name { Faker::Address.street_address }
    f.address { |a| "#{a.name}, #{Faker::Address.city}, #{Faker::Address.country}" }
  end
end
