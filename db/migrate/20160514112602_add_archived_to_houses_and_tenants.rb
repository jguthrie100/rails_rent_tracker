class AddArchivedToHousesAndTenants < ActiveRecord::Migration
  def change
    add_column :houses, :archived, :boolean, null: false, default: false
    add_column :tenants, :archived, :boolean, null: false, default: false
  end
end
