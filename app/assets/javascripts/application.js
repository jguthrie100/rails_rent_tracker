// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

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
