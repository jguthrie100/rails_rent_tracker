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

    if property_snapshot.save
      redirect_to property_path(params[:property_id]), notice: "Added Property Snapshot: <b><i>(#{property_snapshot.start_date_str} - #{property_snapshot.end_date_str})</i></b> to the database"
    else
      redirect_to property_path(params[:property_id]), notice: "Failed to add Property Snapshot: <b><i>(#{property_snapshot.start_date_str} - #{property_snapshot.end_date_str})</i></b> to the database: #{property_snapshot.errors.full_messages.to_sentence}"
    end
  end
end
