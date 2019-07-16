module CsvParsers
  extend ActiveSupport::Concern

  class_methods do
    def parse_csv file
      return 0 if file.nil?

      # ASB CSV files must be preceeded by "asb_" to be recognised as being ASB bank
      return parse_asb(file) if file.original_filename.include?("asb_") && file.content_type == "text/csv"

      return nil
    end

    private
    def parse_asb file
      updates = Hash.new
      updates[:failed] = Array.new
      updates[:successful] = Array.new
      updates[:existing] = 0

      tenants = Tenant.all

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

                  # TODO: Needs logic to work out a specific tenant_Snapshot the transaction belongs to - i.e. needs to look at date of transaction and date of tenant snapshot etc etc
                  transaction.tenant_snapshot = TenantSnapshot.where('tenant_id == ? AND start_date <= ? AND (end_date >= ? OR end_date IS NULL)', t.id, transaction.date, transaction.date)
                                                              .first # redundant as above date logic dictates only 1 snapshot can be returned, but keep it in for posterity and to get TenantSnapshot object rather than 'ActiveRelationship'
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
          updates[:failed].push(["Failed to import any transactions", "File type must be text/csv and in a recognised format"])
        end
      end

      return updates
    end
  end
end