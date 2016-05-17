class PropertySnapshotsController < ApplicationController

  def new
    @property = Property.find(params[:property_id])
  end

  def create
    property_snapshot = PropertySnapshot.new do |hs|
      p = params[:property_snapshot]
      hs.start_date = p[:start_date]
      hs.end_date = p[:end_date]
      hs.num_bedrooms = p[:num_bedrooms]
      hs.weekly_rent = p[:weekly_rent]
      hs.agency_fees = p[:agency_fees]
      hs.property_id = params[:property_id]
    end

    property_snapshot.save
    redirect_to property_path(params[:property_id]), notice: return_notice(property_snapshot, "create")
  end
end
