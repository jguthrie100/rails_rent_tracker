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
      ts.property_snapshot_id = p[:property_snapshot_id]
      ts.weekly_rent = p[:weekly_rent]
      ts.rent_frequency = p[:rent_frequency]
      ts.tenant_id = params[:tenant_id]
      ts.rent_paid_by = Tenant.find(p[:rent_paid_by])
    end

    tenant_snapshot.save
    redirect_to tenant_path(params[:tenant_id]), notice: return_notice(tenant_snapshot, "create")
  end
end
