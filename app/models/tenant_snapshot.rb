class TenantSnapshot < ActiveRecord::Base
  belongs_to :house
  belongs_to :tenant

  # Custom foreign key for linking to the other Tenant that pays the rent for this tenant
  belongs_to :rent_paid_by, :class_name => 'Tenant'

  validates_associated :house
  validates_associated :tenant
  validates_associated :rent_paid_by
  
  validates :house, :tenant, :start_date, presence: true

  validates :rent_frequency, numericality: { only_integer: true,
                                             greater_than_or_equal_to: 1 }
  validates :weekly_rent, numericality: { greater_than_or_equal_to: 0.00 }

  validates_with ValidDateRangeValidator

  def end_date
    if self[:end_date].nil?
      return Date.today
    else
      return self[:end_date]
    end
  end
  def end_date_str
    if self[:end_date].nil?
      return "ongoing"
    else
      return self[:end_date].strftime('%d %b %Y')
    end
  end
  def start_date_str
    return self[:start_date].strftime('%d %b %Y')
  end
end
