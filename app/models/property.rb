class Property < ActiveRecord::Base
  has_many :property_snapshots, inverse_of: :property
  has_many :tenants
  has_many :tenant_snapshots, inverse_of: :tenant

  validates_length_of :name, minimum: 3, allow_blank: false
  validates_length_of :address, minimum: 10, allow_blank: false
  validates_uniqueness_of :name, :address

  def self.archived
    return Property.all.where(archived: true)
  end

  def self.current
    return Property.all.where(archived: false)
  end
end
