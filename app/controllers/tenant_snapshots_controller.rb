class TenantSnapshotsController < ApplicationController

  def new
    @tenant = Tenant.find(params[:tenant_id])
    snapshots = TenantSnapshot.where(:tenant_id => params[:tenant_id])

    @snapshot_dates = Array.new
    snapshots.each do |ss|
      @snapshot_dates.push([ss.start_date, ss.end_date, ss.name])
    end
  end

  def create
    tenant_snapshot = TenantSnapshot.new do |ts|
      p = params[:tenant_snapshot]
      ts.start_date = p[:start_date]
      ts.end_date = p[:end_date]
      ts.weekly_rent = p[:weekly_rent]
      ts.rent_frequency = p[:rent_frequency]
      ts.tenant_id = params[:tenant_id]
      ts.rent_paid_by = Tenant.find(p[:rent_paid_by])
    end

    # Ensure property_snapshot exists for the specified property and timeframe
    existing_date_range = PropertySnapshot.date_range_exists?(model: "Property", model_id: params[:tenant_snapshot][:property_id], start_date: tenant_snapshot.start_date, end_date: tenant_snapshot.end_date)

    # Save tenant snapshot and update join table
    if existing_date_range
      if tenant_snapshot.save
        existing_date_range.each do |ss|
          # Create join records/associations in snapshot_join table
          ss.snapshot_joins.create(tenant_snapshot: tenant_snapshot)
        end
        redirect_to tenant_path(params[:tenant_id]), notice: return_message(record: tenant_snapshot, action: "create") and return
      end
    else
      # Add error string
      tenant_snapshot.errors[:base] << "Snapshot dates don't match up to an existing Property snapshot"
    end

    # Create 'failed_edits' hash which stores all the values from the records that failed to get saved
    failed_edits = Hash.new
    failed_edits['new'] = params[:tenant_snapshot]
    failed_edits['new']['errors'] = tenant_snapshot.errors.keys.map(&:to_s)

    redirect_to back_address(failed_edits.to_param), notice: return_message(record: tenant_snapshot, action: "create")
  end
end
