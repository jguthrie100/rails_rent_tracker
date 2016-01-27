class TenantSnapshotsController < ApplicationController

  def new
    @tenant = Tenant.find(params[:tenant_id])
  end

  def create
    tenant_snapshot = TenantSnapshot.new do |ts|
      p = params[:tenant_snapshot]
      ts.start_date = p[:start_date]
      ts.end_date = p[:end_date]
      ts.house_id = p[:house_id]
      ts.weekly_rent = p[:weekly_rent]
      ts.rent_frequency = p[:rent_frequency]
      ts.tenant_id = params[:tenant_id]
      ts.rent_paid_by = Tenant.find(p[:rent_paid_by])
    end
    if tenant_snapshot.save
      redirect_to tenant_path(params[:tenant_id]), notice: "Added Tenant Snapshot: <b><i>(#{tenant_snapshot.start_date.strftime('%d %b %Y')} - #{tenant_snapshot.end_date.strftime('%d %b %Y')})</b></i> to the database"
    else
      redirect_to tenant_path(params[:tenant_id]), notice: "Failed to add Tenant Snapshot: <b><i>(#{tenant_snapshot.start_date.strftime('%d %b %Y')} - #{tenant_snapshot.end_date.strftime('%d %b %Y')})</i></b> to the database: #{tenant_snapshot.errors.full_messages.to_sentence}"
    end
  end
end
