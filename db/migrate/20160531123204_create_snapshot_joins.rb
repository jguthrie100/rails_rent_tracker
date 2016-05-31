class CreateSnapshotJoins < ActiveRecord::Migration
  def change
    create_table :snapshot_joins do |t|
      t.references :property_snapshot, index: true, foreign_key: true, null: false
      t.references :tenant_snapshot, index: true, foreign_key: true, null: false
      t.timestamps null: false
    end
  end
end
