class NotSubsetOfValidator < ActiveModel::Validator
  def validate(record)
    tenants = Tenant.all
    tenants.each do |t|
      next if t.id == record.id
      if t.payment_handle.include?(record.payment_handle) || record.payment_handle.include?(t.payment_handle)
        record.errors[:base] << "Payment Handle must not be a subset or include a subset of another Tenant's payment_handle (#{record.payment_handle} & #{t.payment_handle})"
        break
      end
    end
  end
end

class Tenant < ActiveRecord::Base
  has_many :tenant_snapshots, inverse_of: :tenant
  has_many :transactions
  belongs_to :house

  validates_associated :house

  validates :name, presence: true
  validates_length_of :name, :payment_handle, minimum: 6, allow_blank: true
  validates_uniqueness_of :name, :payment_handle
  validates_with NotSubsetOfValidator
end
