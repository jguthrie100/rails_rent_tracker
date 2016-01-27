class Transaction < ActiveRecord::Base
  require 'csv'
  
  belongs_to :tenant

  validates_associated :tenant

  validates :bank_account_id, :date, :transaction_id, :amount, presence: true
  validates_uniqueness_of :transaction_id

  # Imports a CSV of banking transactions to the DB
  def self.import(file)
    existing_transactions = 0
    updates = Hash.new
    updates[:failed] = Array.new
    updates[:successful] = Array.new
    updates[:existing] = 0

    tenants = Tenant.all

    return 0 if file.nil?

    # Open CSV file
    File.open(file.path) do |f|
      # ASB CSV files must be preceeded by "asb_" to be recognised as being ASB bank
      if file.original_filename.include?("asb_") && file.content_type == "text/csv"
        f.gets  # burn 1st line

        # Match regex pattern and create full bank account id from the result
        line_match = /^Bank (?<bank>\d+); Branch (?<branch>\d+); Account (?<account>\d+-\d+)/.match(f.gets)
        bank_account_id = line_match[:bank] + "-" + line_match[:branch] + "-" + line_match[:account]

        4.times do f.gets end  # Burn next 4 non-important lines

        # Create new CSV handle. Returns CSV rows as a hash (using header values as keys)
        csv = CSV.new(f, headers: true)
        csv.shift # Burn empty 1st row

        # Loop through all CSV entries
        while line_hash = csv.shift do

          # See if Transaction already exists
          transactions = Transaction.where({ bank_account_id: bank_account_id, transaction_id: line_hash["Unique Id"] })

          if transactions.count > 0
            updates[:existing] += transactions.count
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

            # Loop through each tenant and see if the 'payment_handle' matches the transaction
            # If it does, then tag the transaction as belonging to the tenant
            tenants.each do |t|
              if transaction.payee.include?(t.payment_handle) || transaction.memo.include?(t.payment_handle)
                transaction.tenant = t
                break
              end
            end

            # Save transaction to DB and update counter
            if transaction.save
              updates[:successful].push(transaction)
            else
              updates[:failed].push([line_hash.to_s, transaction.errors.full_messages.to_sentence])
            end
          end
        end
      else
        # Non asb bank CSV file
      end
    end
    return updates
  end
end
