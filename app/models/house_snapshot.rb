class HouseSnapshot < ActiveRecord::Base
  belongs_to :house

  validates_associated :house

  validates :house, presence: true

  validates_with ValidDateRangeValidator
end
