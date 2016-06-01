class PropertiesController < ApplicationController
  def index

    # Determines whether user selected "current", "all", or "archived" properties list
    if params[:view].nil?
      @properties = Property.current
      @list_desc = "Current"
    elsif params[:view] == "archived"
      @properties = Property.archived
      @list_desc = "Archived"
    else
      @properties = Property.all
      @list_desc = "All"
    end
  end

  def show
    @property = Property.find(params[:id])
    @sorted_snapshots = Array.new

    @property.property_snapshots.sort { |a,b| b.start_date <=> a.start_date }.each do |ss|
      @sorted_snapshots.push(ss)
    end
  end

  def edit
    @properties = Property.all
  end

  def destroy
    property = Property.find(params[:id])

    property.destroy
    redirect_to back_address(""), notice: return_message(record: property, action: "destroy")
  end

  def archive
    property = Property.find(params[:id])

    property.archived = true

    property.save
    redirect_to back_address(""), notice: return_message(record: property, action: "archive")
  end

  def unarchive
    property = Property.find(params[:id])

    property.archived = false

    property.save
    redirect_to back_address(""), notice: return_message(record: property, action: "unarchive")
  end

  # Add new Property to DB
  def create
    # Build a new Property object and set the values based on user input
    property = Property.new do |h|
      p = params[:property]
      h.name = p[:name]
      h.address = p[:address]
    end

    # Attempt to save the property
    if property.save  # success
      redirect_to back_address(""), notice: return_message(record: property, action: "create")

    else  # fail
      # Create 'failed_edits' hash which stores all the values from the records that failed to get saved
      failed_edits = Hash.new
      failed_edits['new'] = params[:property]
      failed_edits['new']['errors'] = property.errors.keys.map(&:to_s)

      redirect_to back_address(failed_edits.to_param), notice: return_message(record: property, action: "create")
    end
  end

  # Update multiple property attributes
  def update_multiple
    transaction_ids = params[:properties]
    failed_edits = Hash.new
    property = ""

    updated_rows = 0
    attempted_updates = 0
    error_str = ""

    # Loop through hash of properties
    transaction_ids.each do |p_id, values|
      # If the property has been tagged as being updated, then find the relevant property object and update it
      if values[:is_updated] == "true"
        attempted_updates += 1
        property = Property.find(p_id)

        # Attempt to save the updates
        if property.update_attributes(allowed_params(p_id))  # success
          updated_rows += 1

        else  # fail
          error_str += ": " + property.name + " - " + property.errors.full_messages.to_sentence
          failed_edits[p_id] = values
          failed_edits[p_id]['errors'] = property.errors.keys.map(&:to_s)
        end
      end
    end
    if attempted_updates == 1
      redirect_to back_address(failed_edits.to_param), notice: return_message(record: property, action: "update")
    else
      error_str.blank? ? (pre_string = "Successfully u") : (pre_string = "<strong>Error:</strong> U")
      redirect_to back_address(failed_edits.to_param), notice: "#{pre_string}pdated <strong>#{updated_rows}/#{attempted_updates}</strong> row(s)" + error_str
    end
  end

  # Private method that sets Strong Parameter permissions
  private
  def allowed_params(p_id)
    params.require(:properties).require(p_id).permit(:name, :address, :archived)
  end
end
