class Tenant < ActiveRecord::Base
  has_many :tenant_snapshots, inverse_of: :tenant
  has_many :transactions
  belongs_to :house

  validates_associated :house

  validates :name, presence: true
  validates_length_of :name, :payment_handle, :phone_num, minimum: 6, allow_blank: true
  validates_uniqueness_of :name
  validates :payment_handle, unique_payment_handle: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, allow_blank: true
  validates_format_of :phone_num, :with => /\A\+*[-()0-9\.]+\z/, allow_blank: true
end
