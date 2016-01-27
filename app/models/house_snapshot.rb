class HouseSnapshot < ActiveRecord::Base
  include ModelHelpers
  
  belongs_to :house

  validates_associated :house

  validates :house, :start_date, presence: true

  validates_with ValidDateRangeValidator
end
