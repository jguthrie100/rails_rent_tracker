class HouseSnapshotsController < ApplicationController
  
  def new
    @house = House.find(params[:house_id])
  end

  def create
    house_snapshot = HouseSnapshot.new do |hs|
      p = params[:house_snapshot]
      hs.start_date = p[:start_date]
      hs.end_date = p[:end_date]
      hs.num_bedrooms = p[:num_bedrooms]
      hs.weekly_rent = p[:weekly_rent]
      hs.agency_fees = p[:agency_fees]
      hs.house_id = params[:house_id]
    end
    if house_snapshot.save
      redirect_to house_path(params[:house_id]), notice: "Added House Snapshot: <b><i>(#{house_snapshot.start_date.strftime('%d %b %Y')} - #{house_snapshot.end_date.strftime('%d %b %Y')})</i></b> to the database"
    else
      redirect_to house_path(params[:house_id]), notice: "Failed to add House Snapshot: <b><i>(#{house_snapshot.start_date.strftime('%d %b %Y')} - #{house_snapshot.end_date.strftime('%d %b %Y')})</i></b> to the database: #{house_snapshot.errors.full_messages.to_sentence}"
    end
  end
end
