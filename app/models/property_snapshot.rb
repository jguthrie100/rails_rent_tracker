class PropertySnapshot < ActiveRecord::Base
  include ModelHelpers

  belongs_to :property
  has_many :tenant_snapshots
  has_many :tenants, through: :tenant_snapshots

  validates :property, :start_date, presence: true

  validates_with SnapshotDateRangeValidator, model: "property"
end
