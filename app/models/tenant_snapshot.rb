class TenantSnapshot < ApplicationRecord
  include ModelHelpers

  belongs_to :tenant
  has_many :snapshot_joins
  has_many :property_snapshots, through: :snapshot_joins
  has_many :properties, through: :property_snapshots
  has_many :transactions

  # Custom foreign key for linking to the other Tenant that pays the rent for this tenant
  belongs_to :rent_paid_by, :class_name => 'Tenant'

  validates_presence_of :rent_paid_by, :if => :rent_paid_by

  validates :tenant, :start_date, :rent_frequency, :weekly_rent, presence: true

  validates :rent_frequency, numericality: { only_integer: true,
                                             greater_than_or_equal_to: 1,
                                             allow_blank: true }
  validates :weekly_rent, numericality: { greater_than_or_equal_to: 0.00,
                                          allow_blank: true }

  validates_with SnapshotDateRangeValidator, model: "tenant"

  def property
    properties = self.properties.uniq

    return properties.first if properties.length == 1
    raise StandardError "Only expected one property associated with TenantSnapshot"
  end

  def total_income
    return self.transactions.where('amount > 0.0').map(&:amount).inject(0, :+)
  end

  def total_rent_expected
    return (self.weekly_rent/7)*self.length_in_days
  end

  def total_rent_paid
    return Transaction.where(tenant_snapshot_id: self.id).reduce(0) { |total, t| total += t.amount }
  end
end
