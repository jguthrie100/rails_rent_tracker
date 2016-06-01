class DeletePropertySnapshotIdColumnFromTenantSnapshot < ActiveRecord::Migration
  def up
    remove_column :tenant_snapshots, :property_snapshot_id
  end

  def down
    add_column :tenant_snapshots, :property_snapshot_id, :integer, index: true, foreign_key: true, null: false, default: 0
  end
end
