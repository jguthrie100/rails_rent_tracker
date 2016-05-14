class PropertySnapshot < ActiveRecord::Base
  include ModelHelpers

  belongs_to :property

  validates_associated :property

  validates :property, :start_date, presence: true

  validates_with ValidDateRangeValidator, model: "property"
end
