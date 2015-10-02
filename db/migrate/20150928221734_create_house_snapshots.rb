class CreateHouseSnapshots < ActiveRecord::Migration
  def change
    create_table :house_snapshots do |t|
      t.date :start_date
      t.date :end_date
      t.integer :num_bedrooms
      t.decimal :weekly_rent, precision: 10, scale: 2
      t.decimal :agency_fees, precision: 10, scale: 2
      t.references :house, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
