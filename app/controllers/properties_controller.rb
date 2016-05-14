class PropertiesController < ApplicationController
  def index
    if params[:view].nil?
      @properties = Property.all.where(archived: false)
    elsif params[:view] == "archived"
      @properties = Property.all.where(archived: true)
    else
      @properties = Property.all
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
      redirect_to properties_path, notice: "Deleted property: <b>'#{property.name}'</b> from the database"
    else
      redirect_to properties_path, notice: "Failed to delete property: <b>'#{property.name}'</b> from the database: #{property.errors.full_messages.to_sentence}"
    end
  end

  def archive
    property = Property.find(params[:id])

    property.archived = true

    if property.save
      redirect_to properties_path, notice: "Archived property: <b>'#{property.name}'</b>."
    else
      redirect_to properties_path, notice: "Failed to archive property: <b>'#{property.name}'</b>: #{property.errors.full_messages.to_sentence}"
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
      redirect_to properties_path, notice: "Added property: <b>'#{property.name}'</b> to the database"
    else
      # Create 'failed_edits' hash which stores all the values from the records that failed to get saved
      failed_edits = Hash.new
      failed_edits['new'] = params[:property]
      failed_edits['new']['errors'] = property.errors.keys.map(&:to_s)

      redirect_to properties_path(failed_edits), notice: "Failed to add property: <b>'#{property.name}'</b> to the database: #{property.errors.full_messages.to_sentence}"
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
    redirect_to properties_path(failed_edits), :notice => "Updated <b>#{updated_rows}</b> row(s)" + error_str
  end

  # Private method that sets Strong Parameter permissions
  private
  def allowed_params(p_id)
    params.require(:properties).require(p_id).permit(:name, :address, :archived)
  end
end
