class Transaction < ActiveRecord::Base
  require 'csv'
  
  belongs_to :tenant

  validates_associated :tenant

  validates :bank_account_id, :date, :transaction_id, :amount, presence: true
  validates_uniqueness_of :transaction_id

  def self.import(file)

    File.open(file.path) do |f|
      if file.original_filename.include?("asb_")
        f.gets  # burn 1st line

        # Match regex pattern
        line_match = /^Bank (?<bank>\d+); Branch (?<branch>\d+); Account (?<account>\d+-\d+)/.match(f.gets)

        # Create full bank account num from regex
        bank_account_id = line_match[:bank] + "-" + line_match[:branch] + "-" + line_match[:account]

        4.times do f.gets end  # Burn next 4 non-important lines

        csv = CSV.new(f, headers: true)
        csv.shift # Burn empty 1st row
        
        existing_transactions, new_transactions, failed_updates = 0, 0, 0
        # Loop through all CSV entries
        while line_hash = csv.shift do
          transactions = Transaction.where({ bank_account_id: bank_account_id, transaction_id: line_hash["Unique Id"] })

          if transactions.count > 0
            existing_transactions += 1
          else
            transaction = Transaction.new do |tr|
              tr.bank_account_id = bank_account_id
              tr.date = line_hash["Date"]
              tr.transaction_id = line_hash["Unique Id"]
              tr.transaction_type = line_hash["Tran Type"]
              tr.cheque_num = line_hash["Cheque Number"]
              tr.payee = line_hash["Payee"]
              tr.memo = line_hash["Memo"]
              tr.amount = line_hash["Amount"]
            end

            if transaction.save
              new_transactions += 1
            else
              failed_updates += 1
            end
          end
        end
      else
        # Non asb bank CSV file
      end
    end
  end
end
