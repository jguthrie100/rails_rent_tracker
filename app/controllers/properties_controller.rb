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

    if property.destroy
      redirect_to back_address(""), notice: "Deleted property: <b>'#{property.name}'</b> from the database"
    else
      redirect_to back_address(""), notice: "Failed to delete property: <b>'#{property.name}'</b> from the database: #{property.errors.full_messages.to_sentence}"
    end
  end

  def archive
    property = Property.find(params[:id])

    property.archived = true

    if property.save
      # Using HTTP_REFERER, because we don't know if the page we came from is properties/all or properties/archived etc
      # split('?')[0] gets rid of the query string and just goes back to the vanilla page
      redirect_to back_address(""), notice: "Archived property: <b>'#{property.name}'</b>."
    else
      redirect_to back_address(""), notice: "Failed to archive property: <b>'#{property.name}'</b>: #{property.errors.full_messages.to_sentence}"
    end
  end

  def unarchive
    property = Property.find(params[:id])

    property.archived = false

    if property.save
      redirect_to back_address(""), notice: "Restored property to main properties list: <b>'#{property.name}'</b>."
    else
      redirect_to back_address(""), notice: "Failed to restore property to main properties list: <b>'#{property.name}'</b>: #{property.errors.full_messages.to_sentence}"
    end
  end

  # Add new Property to DB
  def create
    property = Property.new do |h|
      p = params[:property]
      h.name = p[:name]
      h.address = p[:address]
    end
    if property.save
      redirect_to back_address(""), notice: "Added property: <b>'#{property.name}'</b> to the database"
    else
      # Create 'failed_edits' hash which stores all the values from the records that failed to get saved
      failed_edits = Hash.new
      failed_edits['new'] = params[:property]
      failed_edits['new']['errors'] = property.errors.keys.map(&:to_s)

      redirect_to back_address(failed_edits.to_param), notice: "Failed to add property: <b>'#{property.name}'</b> to the database: #{property.errors.full_messages.to_sentence}"
    end
  end

  # Update multiple property attributes
  def update_multiple
    update_hash = params[:properties]
    failed_edits = Hash.new

    updated_rows = 0
    error_str = ""

    # Loop through hash of properties
    update_hash.each do |p_id, values|
      # If the property has been tagged as being updated, then find the relevant property object and update it
      if values[:is_updated] == "true"
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
    redirect_to back_address(failed_edits.to_param), :notice => "Updated <b>#{updated_rows}</b> row(s)" + error_str
  end

  # Private method that sets Strong Parameter permissions
  private
  def allowed_params(p_id)
    params.require(:properties).require(p_id).permit(:name, :address, :archived)
  end

  # returns address that request came from, either with or without params included
  def back_address param_string
    !param_string.blank? ? (return "#{request.env['HTTP_REFERER']}?#{param_string}") : (return request.env['HTTP_REFERER'].split('?')[0])
  end
end
