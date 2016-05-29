class Tenant < ActiveRecord::Base
  has_many :tenant_snapshots, inverse_of: :tenant

  validates_length_of :name, minimum: 4, allow_blank: false
  validates_uniqueness_of :name

  validates_length_of :payment_handle, :phone_num, minimum: 5, allow_blank: true
  validates :payment_handle, unique_payment_handle: true

  validates_format_of :phone_num, :with => /\A\+*[-()0-9\. x]+\z/, allow_blank: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, allow_blank: true

  def self.archived
    return Tenant.where(archived: true).all
  end

  def self.current
    return Tenant.where(archived: false).all
  end

  # Return current property that tenant is staying in
  def property
    if self.tenant_snapshots.last.nil? # no tenant snapshots
      return nil
    elsif self.tenant_snapshots.last.property_snapshot.nil? # no associated property snapshots
      return nil
    else
      return self.tenant_snapshots.last.property_snapshot.property
    end
  end
end
