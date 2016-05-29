class PropertySnapshot < ActiveRecord::Base
  include ModelHelpers

  belongs_to :property
  has_many :tenant_snapshots, inverse_of: :tenant

  validates_associated :property

  validates :property, :start_date, presence: true

  validates_with SnapshotDateRangeValidator, model: "property"
end
