class House < ActiveRecord::Base
  has_many :house_snapshots, inverse_of: :house
  has_many :tenants
  has_many :tenant_snapshots, inverse_of: :tenant

  validates :name, :address, presence: true
  validates_length_of :name, minimum: 3
  validates_length_of :address, minimum: 10
  validates_uniqueness_of :name, :address
end
