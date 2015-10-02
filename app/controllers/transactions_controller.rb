class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
  end

  def edit
    @transactions = Transaction.all
  end

  # Import CSV file to the DB
  def import
    imported_transactions = Transaction.import(params[:file])
    redirect_to root_url, notice: "Imported #{imported_transactions} transaction(s)"
  end

  # Update multiple transaction attributes
  def update_multiple
    update_hash = params[:transactions]

    updated_rows = 0

    # Loop through hash of transactions
    update_hash.each do |t_id, values|
      # If the transaction has been tagged as being updated, then find the relevant Transaction and update it
      if values[:is_updated] == "true"
        transaction = Transaction.find(t_id)
        unless values[:tenant_id].blank?
          tenant = Tenant.find(values[:tenant_id])
        else
          tenant = nil
        end
        transaction.tenant = tenant
        if transaction.save
          updated_rows += 1
        end
      end
    end

    redirect_to transactions_path, :notice => "Updated #{updated_rows} row(s)"
  end
end
