class PropertiesController < ApplicationController
  def index
    if params[:view].nil?
      @properties = Property.current
      @desc = "Current"
    elsif params[:view] == "archived"
      @properties = Property.archived
      @desc = "Archived"
    else
      @properties = Property.all
      @desc = "All"
    end
  end

  def show
    @property = Property.find(params[:id])
  end

  def edit
    @properties = Property.all
  end

  def destroy
    property = Property.find(params[:id])

    property.destroy
    redirect_to back_address(""), notice: return_notice(property, "destroy")
  end

  def archive
    property = Property.find(params[:id])

    property.archived = true

    property.save
    redirect_to back_address(""), notice: return_notice(property, "archive")
  end

  def unarchive
    property = Property.find(params[:id])

    property.archived = false

    property.save
    redirect_to back_address(""), notice: return_notice(property, "unarchive")
  end

  # Add new Property to DB
  def create
    property = Property.new do |h|
      p = params[:property]
      h.name = p[:name]
      h.address = p[:address]
    end
    if property.save
      redirect_to back_address(""), notice: return_notice(property, "create")
    else
      # Create 'failed_edits' hash which stores all the values from the records that failed to get saved
      failed_edits = Hash.new
      failed_edits['new'] = params[:property]
      failed_edits['new']['errors'] = property.errors.keys.map(&:to_s)

      redirect_to back_address(failed_edits.to_param), notice: return_notice(property, "create")
    end
  end

  # Update multiple property attributes
  def update_multiple
    update_hash = params[:properties]
    failed_edits = Hash.new
    property = ""

    updated_rows = 0
    attempted_rows = 0
    error_str = ""

    # Loop through hash of properties
    update_hash.each do |p_id, values|
      # If the property has been tagged as being updated, then find the relevant property object and update it
      if values[:is_updated] == "true"
        attempted_rows += 1
        property = Property.find(p_id)

        if property.update_attributes(allowed_params(p_id))
          updated_rows += 1
        else
          error_str += ": " + property.name + " - " + property.errors.full_messages.to_sentence
          failed_edits[p_id] = values
          failed_edits[p_id]['errors'] = property.errors.keys.map(&:to_s)
        end
      end
    end
    if attempted_rows == 1
      redirect_to back_address(failed_edits.to_param), notice: return_notice(property, "update")
    else
      error_str.blank? ? (pre_string = "Successfully u") : (pre_string = "<strong>Error:</strong> U")
      redirect_to back_address(failed_edits.to_param), notice: "#{pre_string}pdated <strong>#{updated_rows}/#{attempted_rows}</strong> row(s)" + error_str
    end
  end

  # Private method that sets Strong Parameter permissions
  private
  def allowed_params(p_id)
    params.require(:properties).require(p_id).permit(:name, :address, :archived)
  end
end
