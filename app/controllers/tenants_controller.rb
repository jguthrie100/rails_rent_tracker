class TenantsController < ApplicationController
  def index
    @tenants = Tenant.all
  end

  def edit
    @tenants = Tenant.all
  end

  def show
    @tenant = Tenant.find(params[:id])
    @payments = Transaction.where({tenant: @tenant}).order(date: :desc)
    @sorted_snapshots = Array.new
    
    @tenant.tenant_snapshots.sort { |a,b| b.start_date <=> a.start_date }.each do |s|
      @sorted_snapshots.push(s)
    end
  end

  def destroy
    tenant = Tenant.find(params[:id])

    if tenant.destroy
      redirect_to tenants_path, notice: "Deleted Tenant: <b>'#{tenant.name}'</b> from the database"
    else
      redirect_to tenants_path, notice: "Failed to delete Tenant: <b>'#{tenant.name}'</b> from the database: #{tenant.errors.full_messages.to_sentence}"
    end
  end

  # Add new Tenant to DB
  def create
    tenant = Tenant.new do |t|
      p = params[:tenant]
      t.name = p[:name]
      t.payment_handle = p[:payment_handle]
      t.phone_num = p[:phone_num]
      t.email = p[:email]
      t.house_id = p[:house_id]
    end
    if tenant.save
      redirect_to tenants_path, notice: "Added Tenant <b>'#{tenant.name}'</b> to the database"
    else
      redirect_to tenants_path, notice: "Failed to add Tenant <b>'#{tenant.name}'</b> to the database: #{tenant.errors.full_messages.to_sentence}"
    end
  end

  # Update multiple tenant attributes
  def update_multiple
    update_hash = params[:tenants]

    updated_rows = 0
    error_str = ""

    # Loop through hash of tenants
    update_hash.each do |t_id, values|
      # If the tenant has been tagged as being updated, then find the relevant Tenant object and update it
      if values[:is_updated] == "true"
        tenant = Tenant.find(t_id)

        if tenant.update_attributes(allowed_params(t_id))
          updated_rows += 1
        else
          error_str += ": " + tenant.name + " - " + tenant.errors.full_messages.to_sentence
        end
      end
    end
    redirect_to tenants_path, :notice => "Updated <b>#{updated_rows}</b> row(s)" + error_str
  end

  # Private method that sets Strong Parameter permissions
  private
  def allowed_params(t_id)
    params.require(:tenants).require(t_id).permit(:name, :payment_handle, :phone_num, :email, :house_id)
  end
end
