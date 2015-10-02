class CreateTenants < ActiveRecord::Migration
  def change
    create_table :tenants do |t|
      t.string :name, null: false
      t.string :payment_handle, unique: true
      t.string :phone_num
      t.string :email
      t.references :house, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
