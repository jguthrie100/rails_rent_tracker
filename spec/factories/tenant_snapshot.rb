# spec/factories/tenant_snapshot.rb
require 'faker'

FactoryBot.define do
  factory :tenant_snapshot do |f|
    property = FactoryBot.create(:property)
    tenant = FactoryBot.create(:tenant)
    #property
    #tenant

    property1 = Property.last
    tenant1 = Tenant.last

    f.start_date { 3.days.ago }
    #f.property_id { property.id }
    f.weekly_rent { Faker::Number.decimal(3, 2) }
    f.rent_frequency { Faker::Number.between(1, 10) }
    f.tenant { tenant }
  end
end
