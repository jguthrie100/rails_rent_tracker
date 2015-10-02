class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :bank_account_id, index: true, null: false
      t.date :date, null: false
      t.string :transaction_id, unique: true, index: true, null: false
      t.string :transaction_type
      t.string :cheque_num
      t.string :payee
      t.string :memo
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.references :tenant, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
