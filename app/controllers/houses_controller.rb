class HousesController < ApplicationController
  def index
    @houses = House.all
  end

  def show
    @house = House.find(params[:id])
  end

  def edit
    @houses = House.all
  end

  # Add new House to DB
  def create
    house = House.new do |h|
      p = params[:house]
      h.name = p[:name]
      h.address = p[:address]
    end
    if house.save
      redirect_to houses_path, notice: "Added House: <b><i>(#{house.name})</i></b> to the database"
    else
      redirect_to houses_path, notice: "Failed to add House: <b><i>(#{house.name})</i></b> to the database: #{house.errors.full_messages.to_sentence}"
    end
  end

  # Update multiple house attributes
  def update_multiple
    update_hash = params[:houses]

    updated_rows = 0
    error_str = ""

    # Loop through hash of houses
    update_hash.each do |h_id, values|
      # If the house has been tagged as being updated, then find the relevant house object and update it
      if values[:is_updated] == "true"
        house = House.find(h_id)

        if house.update_attributes(allowed_params(h_id))
          updated_rows += 1
        else
          error_str += ": " + house.name + " - " + house.errors.full_messages.to_sentence
        end
      end
    end
    redirect_to houses_path, :notice => "Updated #{updated_rows} row(s)" + error_str
  end

  # Private method that sets Strong Parameter permissions
  private
  def allowed_params(h_id)
    params.require(:houses).require(h_id).permit(:name, :address)
  end
end
