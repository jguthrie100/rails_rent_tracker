require 'csv'

class Transaction < ApplicationRecord
  include ModelHelpers
  include CsvParsers

  scope :date, ->(date) { where(date: date) }
  scope :transaction_type, ->(transaction_type) { where(transaction_type: transaction_type) }
  scope :payee2, ->(payee) { where(payee: payee) }
  scope :bank_acc_id, ->(bank_acc_id) { where(bank_account_id: bank_acc_id) }

  belongs_to :tenant_snapshot
  has_one :tenant, through: :tenant_snapshot

  validates :bank_account_id, :date, :transaction_id, :amount, presence: true
  validates_uniqueness_of :transaction_id
  validates_presence_of :tenant_snapshot, :if => :tenant_snapshot_id

  def formatted_s
    "#{self.transaction_id} - #{self.transaction_type} - #{self.payee} - #{self.memo} - #{self.amount_str}"
  end

  # Imports a CSV of banking transactions to the DB
  def self.import(file)
    return parse_csv file
  end
end
