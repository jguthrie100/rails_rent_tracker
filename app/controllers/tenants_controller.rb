class TenantsController < ApplicationController
  def index
    if params[:view].nil?
      @tenants = Tenant.all.where(archived: false)
    elsif params[:view] == "archived"
      @tenants = Tenant.all.where(archived: true)
    else
      @tenants = Tenant.all
    end
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
      redirect_to tenants_path, notice: "Deleted tenant: <b>'#{tenant.name}'</b> from the database"
    else
      redirect_to tenants_path, notice: "Failed to delete tenant: <b>'#{tenant.name}'</b> from the database: #{tenant.errors.full_messages.to_sentence}"
    end
  end

  def archive
    tenant = Tenant.find(params[:id])

    tenant.archived = true

    if tenant.save
      redirect_to tenants_path(:view => 'archived'), notice: "Archived tenant: <b>'#{tenant.name}'</b>."
    else
      redirect_to tenants_path(:view => 'all'), notice: "Failed to archive tenant: <b>'#{tenant.name}'</b>: #{tenant.errors.full_messages.to_sentence}"
    end
  end

  def unarchive
    tenant = Tenant.find(params[:id])

    tenant.archived = false

    if tenant.save
      redirect_to tenants_path(:view => 'all'), notice: "Restored tenant to main tenants list: <b>'#{tenant.name}'</b>."
    else
      redirect_to tenants_path(:view => 'all'), notice: "Failed to restore tenant to main tenants list: <b>'#{tenant.name}'</b>: #{tenant.errors.full_messages.to_sentence}"
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
      t.property_id = p[:property_id]
    end
    if tenant.save
      redirect_to tenants_path, notice: "Added tenant <b>'#{tenant.name}'</b> to the database"
    else
      # Create 'failed_edits' hash which stores all the values from the records that failed to get saved
      failed_edits = Hash.new
      failed_edits['new'] = params[:tenant]
      failed_edits['new']['errors'] = tenant.errors.keys.map(&:to_s)

      redirect_to tenants_path(failed_edits), notice: "Failed to add tenant <b>'#{tenant.name}'</b> to the database: #{tenant.errors.full_messages.to_sentence}"
    end
  end

  # Update multiple tenant attributes
  def update_multiple
    update_hash = params[:tenants]
    failed_edits = Hash.new

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
          failed_edits[t_id] = values
          failed_edits[t_id]['errors'] = tenant.errors.keys.map(&:to_s)
        end
      end
    end
    redirect_to tenants_path(failed_edits), :notice => "Updated <b>#{updated_rows}</b> row(s)" + error_str
  end

  # Private method that sets Strong Parameter permissions
  private
  def allowed_params(t_id)
    params.require(:tenants).require(t_id).permit(:name, :payment_handle, :phone_num, :email, :property_id)
  end
end
