# spec/factories/tenant_snapshot.rb
require 'faker'

FactoryGirl.define do
  factory :tenant_snapshot do |f|
    #FactoryGirl.create(:house)
    #FactoryGirl.create(:tenant)
    house
    tenant

    house1 = House.last
    tenant1 = Tenant.last

    f.start_date { Faker::Date.backward(365) }
    f.house_id { house1.id }
    f.weekly_rent { Faker::Number.decimal(3, 2) }
    f.rent_frequency { Faker::Number.between(1, 10) }
    f.tenant_id { tenant1.id }

  #  f.address { |a| "#{a.name}, #{Faker::Address.city}, #{Faker::Address.country}" }
  end
end
