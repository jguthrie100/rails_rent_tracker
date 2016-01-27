class Tenant < ActiveRecord::Base
  has_many :tenant_snapshots, inverse_of: :tenant
  has_many :transactions
  belongs_to :house

  validates_associated :house

  validates :name, presence: true
  validates_length_of :name, :payment_handle, minimum: 6, allow_blank: true
  validates_uniqueness_of :name, :payment_handle
  validates :payment_handle, unique_payment_handle: true
end
