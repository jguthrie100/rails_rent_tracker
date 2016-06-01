class TenantsController < ApplicationController
  def index
    if params[:view].nil?
      @tenants = Tenant.current
      @list_desc = "Current"
    elsif params[:view] == "archived"
      @tenants = Tenant.archived
      @list_desc = "Archived"
    else
      @tenants = Tenant.all
      @list_desc = "All"
    end
  end

  def edit
    @tenants = Tenant.all
  end

  def show
    @tenant = Tenant.includes(:tenant_snapshots).find(params[:id])
    @payments = Transaction.joins(:tenant_snapshot).where(tenant_snapshots: {tenant_id: @tenant}).order(date: :desc)
    @tenant_snapshots = Array.new

    @tenant.tenant_snapshots.sort { |a,b| b.start_date <=> a.start_date }.each do |s|
      @tenant_snapshots.push(s)
    end
  end

  def destroy
    tenant = Tenant.find(params[:id])
    tenant.destroy

    redirect_to back_address(""), notice: return_notice(tenant, "destroy")
  end

  def archive
    tenant = Tenant.find(params[:id])

    tenant.archived = true

    tenant.save
    redirect_to back_address(""), notice: return_notice(tenant, "archive")
  end

  def unarchive
    tenant = Tenant.find(params[:id])

    tenant.archived = false

    tenant.save
    redirect_to back_address(""), notice: return_notice(tenant, "unarchive")
  end

  # Add new Tenant to DB
  def create
    # Build a new Tenant object and set the values based on user input
    tenant = Tenant.new do |t|
      p = params[:tenant]
      t.name = p[:name]
      t.payment_handle = p[:payment_handle]
      t.phone_num = p[:phone_num]
      t.email = p[:email]
    end

    # Attempt to save the tenant
    if tenant.save  # success
      redirect_to back_address(""), notice: return_notice(tenant, "create")

    else  # fail
      # Create 'failed_edits' hash which stores all the values from the records that failed to get saved
      failed_edits = Hash.new
      failed_edits['new'] = params[:tenant]
      failed_edits['new']['errors'] = tenant.errors.keys.map(&:to_s)

      redirect_to back_address(failed_edits.to_param), notice: return_notice(tenant, "create")
    end
  end

  # Update multiple tenants
  def update_multiple
    transaction_ids = params[:tenants]
    failed_edits = Hash.new
    tenant = ""

    updated_rows = 0
    attempted_updates = 0
    error_str = ""

    # Loop through hash of tenants
    transaction_ids.each do |t_id, values|
      # If the tenant has been tagged as being updated, then find the relevant Tenant object and update it
      if values[:is_updated] == "true"
        attempted_updates += 1
        tenant = Tenant.find(t_id)

        # Attempt to save the updates
        if tenant.update_attributes(allowed_params(t_id))  # success
          updated_rows += 1

        else  # fail
          error_str += ": " + tenant.name + " - " + tenant.errors.full_messages.to_sentence
          failed_edits[t_id] = values
          failed_edits[t_id]['errors'] = tenant.errors.keys.map(&:to_s)
        end
      end
    end
    if attempted_updates == 1
      redirect_to back_address(failed_edits.to_param), notice: return_notice(tenant, "update")
    else
      error_str.blank? ? (pre_string = "Successfully u") : (pre_string = "<strong>Error:</strong> U")
      redirect_to back_address(failed_edits.to_param), notice: "#{pre_string}pdated <strong>#{updated_rows}/#{attempted_updates}</strong> row(s)" + error_str
    end
  end

  # Private method that sets Strong Parameter permissions
  private
  def allowed_params(t_id)
    params.require(:tenants).require(t_id).permit(:name, :payment_handle, :phone_num, :email)
  end
end
