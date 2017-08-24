$(document).on('turbolinks:load', function() {
  page = window.location['pathname'].split('/')[1]
  if(page === "tenants") {
    row_name = "#tenant_row_";
    row_class = ".tenant_row";
  } else if (page === "properties") {
    row_name = "#property_row_";
    row_class = ".property_row";
  } else if (page === "transactions") {
    row_name = "#transaction_row_";
    row_class = ".transaction_row";
  } else {
    row_name = "#record_row_";
    row_class = ".record_row";
  }
});

// Method that gets called everytime a checkbox is selected
function toggle_edit(id) {
  if ( $("#checkbox_" + id).prop("checked") ) {
    // WHEN A ROW IS SELECTED..

    // Enable the Save button
    $("#save_btn_" + id).removeClass("disabled")
                        .prop("disabled", false);

    // Hide all the display fields and show and enable all the edit fields
    $(".display", row_name + id).css("visibility", "hidden");
    $(".edit", row_name + id).prop("disabled", false);
    $(".edit", row_name + id).css("visibility", "visible");

    // Fade out the unselected rows and disable the checkboxes on them
    $(row_class + ":not(" + row_name + id + ")").css("opacity", "0.5");
    $(".checkbox:not(#checkbox_" + id + ")").prop("disabled", true);

    // Handles archived rows to remove special formatting when editing
    $(row_name + id).css("opacity", 1);

  } else {
    // WHEN A ROW IS DESELECTED..

    // Disable save button
    $("#save_btn_" + id).addClass("disabled")
                        .prop("disabled", true);

    // Hide and disable all the edit fields and display the display fields
    $(".edit", row_name + id).prop("disabled", true);
    $(".edit", row_name + id).css("visibility", "hidden");
    $(".display", row_name + id).css("visibility", "visible");

    // Fade all the other rows back in and enable all the checkboxes
    $(row_class).css("opacity", "1");
    $(".checkbox").prop("disabled", false);

    // Handles archived rows to return special formatting once editing is finished
    $(".archived").css("opacity", 0.7);
  }
}

function toggle_info(prefix, id) {
  var content_class = "." + prefix + "_content";
  var main = "#" + prefix + "_" + id;

  if ($(content_class, main).is(":hidden") ) {
    $(content_class, main).slideDown("fast");
    $(content_class + "_button", main).text("[hide]");
  } else {
    $(content_class, main).slideUp("fast");
    $(content_class + "_button", main).text("[display]");
  }
}

// Function to determine whether a specific date on the datepicker should be greyed out
function is_date_available(cal_date) {

  // Array of existing Snapshot dates
  var existing_snapshot_dates = $('.snapshot_dates').data('dates');

  // Loop through each existing snapshot
  for(i = 0; i < existing_snapshot_dates.length; i++) {

    // Convert text dates to Date objects
    ss_range = []
    for(j = 0; j < 2; j++) {
      y = parseInt(existing_snapshot_dates[i][j].substring(0, 4));
      m = parseInt(existing_snapshot_dates[i][j].substring(5, 7))-1;
      d = parseInt(existing_snapshot_dates[i][j].substring(8, 10));
      ss_range[j] = new Date(y, m, d, 0, 0, 0, 0);
    }

    // If datepicker cal date clashes with existing snapshot, grey it out
    if(cal_date >= ss_range[0] && cal_date <= ss_range[1]) {
      return [false, "disabled_date", "Existing rental period: " + existing_snapshot_dates[i][2]];
    }
  }
  return [true, "enabled_date", "Available date"];
}

$(document).on('turbolinks:load', function() {
  // Build datepicker object
  $('.snapshot_datepicker').datepicker({
    dateFormat: "dd/mm/yy",
    beforeShowDay: is_date_available,
    numberOfMonths: 2,
    changeMonth: true,
    changeYear: true,
    onClose: function(dateText) {
      $('.snapshot_datepicker').datepicker("option", "defaultDate", dateText);
    }
  });
});
