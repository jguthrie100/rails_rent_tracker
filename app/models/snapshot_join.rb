class SnapshotJoin < ActiveRecord::Base
  belongs_to :property_snapshot
  belongs_to :tenant_snapshot

  validates :property_snapshot, :tenant_snapshot, presence: true
end
