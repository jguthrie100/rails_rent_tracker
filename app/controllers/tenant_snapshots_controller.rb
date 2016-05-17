class TenantSnapshotsController < ApplicationController

  def new
    @tenant = Tenant.find(params[:tenant_id])
  end

  def create
    tenant_snapshot = TenantSnapshot.new do |ts|
      p = params[:tenant_snapshot]
      ts.start_date = p[:start_date]
      ts.end_date = p[:end_date]
      ts.property_id = p[:property_id]
      ts.weekly_rent = p[:weekly_rent]
      ts.rent_frequency = p[:rent_frequency]
      ts.tenant_id = params[:tenant_id]
      ts.rent_paid_by = Tenant.find(p[:rent_paid_by])
    end

    tenant_snapshot.save
    redirect_to tenant_path(params[:tenant_id]), notice: return_notice(tenant_snapshot, "create")
  end
end
