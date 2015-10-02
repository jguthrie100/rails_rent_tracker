class TenantsController < ApplicationController
  def index
    @tenants = Tenant.all
  end

  def edit
    @tenants = Tenant.all
  end

  # NEEDS FINISHING
  def create
    render plain: params.inspect
  end

  # NEEDS FINISHING
  # Update multiple tenant attributes
  def update_multiple
    update_hash = params[:tenants]

    updated_rows = 0

    # Loop through hash of tenants
    update_hash.each do |t_id, values|
      # If the tenant has been tagged as being updated, then find the relevant Tenant object and update it
      if values[:is_updated] == "true"
        tenant = Tenant.find(t_id)

        transaction.tenant = tenant
        if transaction.save
          updated_rows += 1
        end
      end
    end
    render plain: update_hash.inspect
  #  redirect_to transactions_path, :notice => "Updated #{updated_rows} row(s)"
  end
end
