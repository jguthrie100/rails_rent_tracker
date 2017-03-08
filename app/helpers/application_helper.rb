module ApplicationHelper
  def highlight_validation_errors model:, failed_edits:
    output = ""

    # On load we want to select the error'd rows and highlight the fields that raised an error
    output << '$(document).ready(function() {' << "\n"
    output << '  $(".edit").prop("disabled", true);' << "\n"
    output << "\n"

    # Automatically select and highlight row that failed to update/be saved and threw the error
    failed_edits.keys.each do |record_id|
      record_id.is_a?(String) ? (record_id_s = "'#{record_id}'") : (record_id_s = record_id.to_s)

      output << '  $("#checkbox_" + ' << record_id_s << ').prop("checked", true);' << "\n"
      output << '  toggle_edit(' << record_id_s << ');' << "\n"
      output << "\n"

      # Highlight the attributes that were the reason for the error
      failed_edits[record_id].keys.each do |attr|
        next unless failed_edits[record_id]['errors'].include? attr
        output << '  $(".' << attr.to_s << '.edit", ' << '"#' << model << '_row_" + ' << record_id_s << ').addClass("error");' << "\n"
      end
    end
    output << '});' << "\n"

    return output.html_safe
  end
end
