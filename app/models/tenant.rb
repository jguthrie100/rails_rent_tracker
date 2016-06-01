class Tenant < ActiveRecord::Base
  has_many :tenant_snapshots
  has_many :properties, through: :tenant_snapshots
  has_many :transactions, through: :tenant_snapshots

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
  def current_property
    latest_t_snapshot = self.tenant_snapshots.order(:start_date).last
    if latest_t_snapshot.nil? # no tenant snapshots
      return nil
    elsif latest_t_snapshot.end_date < Date.today # old tenant snapshots
      return nil
    else
      return latest_t_snapshot.properties.first
    end
  end
end
