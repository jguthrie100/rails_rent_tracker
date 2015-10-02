class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
  end

  def import
    Transaction.import(params[:file])
    redirect_to root_url, notice: "Transactions imported"
  end

  def update_multiple
    update_hash = params[:transactions]
    string = ""
    update_hash.each do |t_id, value|
      if value[:is_updated] == "true"
        transaction = Transaction.find(t_id)
        unless value[:tenant_id].blank?
          tenant = Tenant.find(value[:tenant_id])
        else
          tenant = nil
        end
        transaction.tenant = tenant
        transaction.save
        string += "Updated transaction: " + t_id + ", "
      end
    end
    render plain: string
  end
end
