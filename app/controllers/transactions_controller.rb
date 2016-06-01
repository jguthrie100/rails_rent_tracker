class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.includes(:tenant_snapshot).all.reverse
  end

  def edit
    @transactions = Transaction.includes(:tenant_snapshot).all.reverse
  end

  # Import CSV file to the DB
  def import
    imported_transactions = Transaction.import(params[:file])

    # Create status string
    update_str = "Successfully imported <strong>#{imported_transactions[:successful].count}</strong> transaction(s)"
    if imported_transactions[:failed].count > 0
      update_str += "<br />Failed to import <strong>#{imported_transactions[:failed].count}</strong> transaction(s):"
      imported_transactions[:failed].each do |f|
        update_str += "<li>#{f[0]} - #{f[1]}</li>"
      end
    end
    if imported_transactions[:existing] > 0
      update_str += "<br /><strong>#{imported_transactions[:existing]}</strong> transaction(s) already exist in the database"
    end

    redirect_to transactions_path, notice: update_str
  end

  # Update multiple transaction attributes
  def update_multiple
    transaction_ids = params[:transactions]
    failed_edits = Hash.new
    transaction = ""

    updated_rows = 0
    attempted_updates = 0
    error_str = ""

    # Loop through hash of transactions
    transaction_ids.each do |tr_id, values|
      # If the transaction has been tagged as being updated, then find the relevant Transaction and update it
      if values[:is_updated] == "true"
        attempted_updates += 1
        transaction = Transaction.find(tr_id)

        # Attempt to save the updates
        if transaction.update_attributes(allowed_params(tr_id))  # success
          updated_rows += 1

        else  # fail
          error_str += ": " + transaction.transaction_id + " - " + transaction.errors.full_messages.to_sentence
          failed_edits[tr_id] = values
          failed_edits[tr_id]['errors'] = transaction.errors.keys.map(&:to_s)
        end
      end
    end
    if attempted_updates == 1
      redirect_to back_address(failed_edits.to_param), notice: return_message(record: transaction, action: "update")
    else
      error_str.blank? ? (pre_string = "Successfully u") : (pre_string = "<strong>Error:</strong> U")
      redirect_to back_address(failed_edits.to_param), notice: "#{pre_string}pdated <strong>#{updated_rows}/#{attempted_updates}</strong> row(s)" + error_str
    end
  end

  # Private method that sets Strong Parameter permissions
  private
  def allowed_params(tr_id)
    params.require(:transactions).require(tr_id).permit(:tenant_snapshot_id)
  end
end
