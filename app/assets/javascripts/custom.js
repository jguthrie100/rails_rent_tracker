$(document).on('ready turbolinks:load', function() {
  get_row_type();
  calendar_button_init();
});

function get_row_type() {
  page = window.location['pathname'].split('/')[1]
  if(/^tenants/.test(page)) {
    model = "tenant";
  } else if (/^properties/.test(page)) {
    model = "property";
  } else if (/^transactions/.test(page)) {
    model = "transaction";
  } else {
    model = "record";
  }

  row_name = `#${model}_row_`;
  row_class = `.${model}_row`;
}

// Method called everytime a checkbox is selected
function toggle_edit(id) {
  get_row_type();

  // WHEN A ROW SELECTED..
  if ( $("#checkbox_" + id).prop("checked") ) {

    // Enable save button
    $("#save_btn_" + id).removeClass("disabled")
                        .prop("disabled", false);

    // Hide all display fields and show and enable all edit fields
    $(".display", row_name + id).css("visibility", "hidden");
    $(".edit", row_name + id).prop("disabled", false);
    $(".edit", row_name + id).css("visibility", "visible");

    // Fade out unselected rows and disable checkboxes on them
    $(row_class + ":not(" + row_name + id + ")").css("opacity", "0.5");
    $(".checkbox:not(#checkbox_" + id + ")").prop("disabled", true);

    // Handle archived rows to remove special formatting when editing
    $(row_name + id).css("opacity", 1);

  // WHEN A ROW DESELECTED..
  } else {

    // Disable save button
    $("#save_btn_" + id).addClass("disabled")
                        .prop("disabled", true);

    // Hide and disable edit fields and enable display fields
    $(".edit", row_name + id).prop("disabled", true);
    $(".edit", row_name + id).css("visibility", "hidden");
    $(".display", row_name + id).css("visibility", "visible");

    // Fade other rows back in and enable checkboxes
    $(row_class).css("opacity", "1");
    $(".checkbox").prop("disabled", false);

    // Handle archived rows to return special formatting once editing is finished
    $(".archived").css("opacity", 0.7);
  }
}

function toggle_snapshot_info(id) {
  toggle_info("snapshot", id);
}

function toggle_payment_info(id) {
  toggle_info("payment", id);
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

// Determine whether a specific date on the datepicker should be greyed out
function is_date_available(cal_date) {

  // Array of existing Snapshot dates
  var existing_snapshot_dates = $('.snapshot_dates').data('dates');

  // Loop through existing snapshots
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

$(document).on('ready turbolinks:load', function() {
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

function calendar_button_init() {
  $("#calendar_button").unbind("click");
  $("#calendar_button").click(function() {
    if($("#calendar_tab").is(":hidden")) {
      $("#calendar_tab").slideDown("slow", function() {
        $("#calendar_button").html('Hide Calendar <span class="caret"></span>');
      });
    } else {
      $("#calendar_tab").slideUp( "slow", function() {
        $("#calendar_button").html('Show Calendar <span class="caret"></span>');
      });
    }
  });
}

function showMap() {
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 4
  });

  var bound = new google.maps.LatLngBounds();
  var markers = new Array();

  for(var i = 0; i < addresses.length; i++) {
    markers[i] = new google.maps.Marker({
        map: map,
        position: {lat: addresses[i][3], lng: addresses[i][4]}
    });
    var url = $('#property_' + addresses[i][0] + '_url').prop("href");
    var contentString = `<small><b>${addresses[i][1]}</b><br /><b>${addresses[i][2]}</b><br /><a href="${url}">Go to property</a>`;
    var infowindow = new google.maps.InfoWindow({
      content: contentString
    });
    bindInfoWindow(markers[i], map, infowindow, contentString);
    bound.extend(markers[i].position);
  }

  if(addresses.length === 1) {
    map.setCenter(new google.maps.LatLng(addresses[0][3], addresses[0][4]));
    map.setZoom(12);
  } else {
    var markerCluster = new MarkerClusterer(map, markers,
      {imagePath: '/assets/gmaps/m'});
    map.fitBounds(bound);
  }
}

function bindInfoWindow(marker, map, infowindow, html) {
  marker.addListener('click', function() {
    infowindow.setContent(html);
    infowindow.open(map, this);
  });
}
