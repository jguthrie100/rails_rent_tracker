class CreateTenantSnapshots < ActiveRecord::Migration
  def change
    create_table :tenant_snapshots do |t|
      t.date :start_date, null: false
      t.date :end_date
      t.references :house, index: true, foreign_key: true, null: false
      t.decimal :weekly_rent, precision: 10, scale: 2, null: false
      t.integer :rent_frequency, null: false
      t.references :tenant, index: true, foreign_key: true, null: false
      t.references :rent_paid_by, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
