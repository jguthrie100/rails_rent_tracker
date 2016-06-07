class AddUniqueIndexToTransactions < ActiveRecord::Migration
  def up
    remove_index :transactions, :name => 'index_transactions_on_transaction_id'
    add_index :transactions, [:bank_account_id, :transaction_id], :unique => true, :name => "index_unique_transactions"
  end
  def down
    remove_index :transactions, :name => 'index_unique_transactions'
    add_index :transactions, :transaction_id
  end
end
