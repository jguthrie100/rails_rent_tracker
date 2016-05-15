class Tenant < ActiveRecord::Base
  has_many :tenant_snapshots, inverse_of: :tenant
  has_many :transactions
  belongs_to :property

  validates_presence_of :property, :if => :property_id

  validates_length_of :name, minimum: 4, allow_blank: false
  validates_uniqueness_of :name

  validates_length_of :payment_handle, :phone_num, minimum: 5, allow_blank: true
  validates :payment_handle, unique_payment_handle: true

  validates_format_of :phone_num, :with => /\A\+*[-()0-9\. x]+\z/, allow_blank: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, allow_blank: true

  def self.archived
    return Tenant.all.where(archived: true)
  end

  def self.current
    return Tenant.all.where(archived: false)
  end
end
