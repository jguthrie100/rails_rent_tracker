class House < ActiveRecord::Base
  has_many :house_snapshots, inverse_of: :house
  has_many :tenants
  has_many :tenant_snapshots, inverse_of: :tenant

  validates_length_of :name, minimum: 3, allow_blank: false
  validates_length_of :address, minimum: 10, allow_blank: false
  validates_uniqueness_of :name, :address
end
