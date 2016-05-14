class RenameHousesToProperties < ActiveRecord::Migration
  def change
    rename_column :tenants, :house_id, :property_id
    rename_column :tenant_snapshots, :house_id, :property_id
    rename_column :house_snapshots, :house_id, :property_id
    rename_table :houses, :properties
    rename_table :house_snapshots, :property_snapshots
  end
end
