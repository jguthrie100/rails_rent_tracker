class ChangeSnapshotAssociations < ActiveRecord::Migration
  def up
    #Remove any association of Tenant to other models
    remove_index :tenants, name: "index_tenants_on_property_id"
    remove_column :tenants, :property_id

    # Change Transaction so its related to a TenantSnapshot and not a Tenant
    remove_index :transactions, name: "index_transactions_on_tenant_id"
    rename_column :transactions, :tenant_id, :tenant_snapshot_id
    add_index "transactions", ["tenant_snapshot_id"], name: "index_transactions_on_tenant_snapshot_id"

    # Change TenantSnapshot so it associates with a PropertySnapshot and not a Property
    remove_index :tenant_snapshots, name: "index_tenant_snapshots_on_property_id"
    rename_column :tenant_snapshots, :property_id, :property_snapshot_id
    add_index "tenant_snapshots", ["property_snapshot_id"], name: "index_tenant_snapshots_on_property_snapshot_id"
  end

  def down
    add_column :tenants, :property_id, :integer
    add_index "tenants", ["property_id"], name: "index_tenants_on_property_id"

    remove_index :transactions, name: "index_transactions_on_tenant_snapshot_id"
    rename_column :transactions, :tenant_snapshot_id, :tenant_id
    add_index "transactions", ["tenant_id"], name: "index_transactions_on_tenant_id"

    remove_index :tenant_snapshots, name: "index_tenant_snapshots_on_property_snapshot_id"
    rename_column :tenant_snapshots, :property_snapshot_id, :property_id
    add_index "tenant_snapshots", ["property_id"], name: "index_tenant_snapshots_on_property_id"
  end
end
