class TenantSnapshot < ActiveRecord::Base
  include ModelHelpers

  belongs_to :property
  belongs_to :tenant

  # Custom foreign key for linking to the other Tenant that pays the rent for this tenant
  belongs_to :rent_paid_by, :class_name => 'Tenant'

  validates_presence_of :rent_paid_by, :if => :rent_paid_by

  validates :property, :tenant, :start_date, :rent_frequency, :weekly_rent, presence: true

  validates :rent_frequency, numericality: { only_integer: true,
                                             greater_than_or_equal_to: 1,
                                             allow_blank: true }
  validates :weekly_rent, numericality: { greater_than_or_equal_to: 0.00,
                                          allow_blank: true }

  validates_with ValidDateRangeValidator, model: "tenant"
end
