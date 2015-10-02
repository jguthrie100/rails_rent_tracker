class HousesController < ApplicationController
  def index
    @houses = House.all
  end

  def edit
    @houses = House.all
  end

  # NEEDS FINISHING
  def create
  end

  # NEEDS FINISHING
  # Update multiple House attributes
  def update_multiple
    update_hash = params[:houses]

    updated_rows = 0

    # Loop through hash of houses
    update_hash.each do |h_id, values|
      # If the house has been tagged as being updated, then find the relevant House object and update it
      if values[:is_updated] == "true"
        house = House.find(h_id)

        transaction.tenant = tenant
        if transaction.save
          updated_rows += 1
        end
      end
    end
    render plain: update_hash.inspect
  #  redirect_to transactions_path, :notice => "Updated #{updated_rows} row(s)"
  end
end
