class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all.reverse
  end

  def edit
    @transactions = Transaction.all.reverse
  end

  # Import CSV file to the DB
  def import
    imported_transactions = Transaction.import(params[:file])

    # Create status string
    update_str = "<b>#{imported_transactions[:successful].count}</b> transaction(s) successfully imported"
    if imported_transactions[:failed].count > 0
      update_str += "<br /><b>#{imported_transactions[:failed].count}</b> transaction(s) failed to import:"
      imported_transactions[:failed].each do |f|
        update_str += "<li>#{f[0]} - #{f[1]}</li>"
      end
    end
    if imported_transactions[:existing] > 0
      update_str += "<br /><b>#{imported_transactions[:existing]}</b> transaction(s) already in database"
    end

    redirect_to transactions_path, notice: update_str
  end

  # Update multiple transaction attributes
  def update_multiple
    update_hash = params[:transactions]

    updated_rows = 0
    error_str = ""

    # Loop through hash of transactions
    update_hash.each do |tr_id, values|
      # If the transaction has been tagged as being updated, then find the relevant Transaction and update it
      if values[:is_updated] == "true"
        transaction = Transaction.find(tr_id)
        if transaction.update_attributes(allowed_params(tr_id))
          updated_rows += 1
        else
          error_str += ": " + transaction.transaction_id + " - " + transaction.errors.full_messages.to_sentence
        end
      end
    end

    redirect_to transactions_path, :notice => "Updated <b>#{updated_rows}</b> row(s)" + error_str
  end

  # Private method that sets Strong Parameter permissions
  private
  def allowed_params(tr_id)
    params.require(:transactions).require(tr_id).permit(:tenant_id)
  end
end
