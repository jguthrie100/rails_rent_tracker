module ControllerHelpers
  # returns address that request came from, either with or without params included
  # Using HTTP_REFERER, because we don't know if the page we came from is properties/all or properties/archived etc
  # split('?')[0] gets rid of the query string and just goes back to the vanilla page
  # :back returns to the previous page, but includes the full query string, so can't use that :(
  # --- can't think of a better way to do this than this way, despite how long winded it seems!
  def back_address param_string
    return "#{request.env['HTTP_REFERER'].split('?')[0]}?#{param_string}"
  end

  def return_notice record, action
    model_name = record.class.name.titleize # -> "TenantSnapshot -> Tenant Snapshot"
    is_error = !record.errors.messages.blank?

    if action == "destroy"
      if !is_error
        return "Successfully deleted #{model_name.downcase}: <strong>'#{record.name}'</strong> from the database"
      else
        return "<strong>Error:</strong> Failed to delete #{model_name.downcase}: <strong>'#{record.name}'</strong> from the database: #{record.errors.full_messages.to_sentence}"
      end
    elsif action == "archive"
      if !is_error
        return "Successfully archived #{model_name.downcase}: <strong>'#{record.name}'</strong>."
      else
        return "<strong>Error:</strong> Failed to archive #{model_name.downcase}: <strong>'#{record.name}'</strong>: #{record.errors.full_messages.to_sentence}"
      end
    elsif action == "unarchive"
      if !is_error
        return "Successfully restored #{model_name.downcase}: <strong>'#{record.name}'</strong> to the main #{model_name.downcase}s list."
      else
        return "<strong>Error:</strong> Failed to restore #{model_name.downcase}: <strong>'#{record.name}'</strong> to the main #{model_name.downcase}s list: #{record.errors.full_messages.to_sentence}"
      end
    elsif action == "create"
      if !is_error
        return "Successfully added #{model_name.downcase}: <strong>'#{record.name}'</strong> to the database"
      else
        return "<strong>Error:</strong> Failed to add #{model_name.downcase}: <strong>'#{record.name}'</strong> to the database: #{record.errors.full_messages.to_sentence}"
      end
    elsif action == "update"
      if !is_error
        return "Successfully updated #{model_name.downcase}: <strong>'#{record.name}'</strong>"
      else
        return "<strong>Error:</strong> Failed to update #{model_name.downcase}: <strong>'#{record.name}'</strong>: #{record.errors.full_messages.to_sentence}"
      end
    end
  end
end
