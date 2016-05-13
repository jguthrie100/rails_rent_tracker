# spec/factories/house.rb
require 'faker'

FactoryGirl.define do
  factory :house do |f|
    f.name { Faker::Address.street_address }
    f.address { |a| "#{a.name}, #{Faker::Address.city}, #{Faker::Address.country}" }
  end
end
