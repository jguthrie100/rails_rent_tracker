class PropertySnapshotsController < ApplicationController

  def new
    @property = Property.find(params[:property_id])
    snapshots = PropertySnapshot.where(:property_id => params[:property_id])

    @snapshot_dates = Array.new
    snapshots.each do |ss|
      @snapshot_dates.push([ss.start_date, ss.end_date, ss.name])
    end
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
    redirect_to property_path(params[:property_id]), notice: return_message(record: property_snapshot, action: "create")
  end
end
