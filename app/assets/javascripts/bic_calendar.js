/*
 *
 * bic calendar
 * Autor: bichotll
 * Web-autor: bic.cat
 * Web script: http://bichotll.github.io/bic_calendar/
 * Llicència Apache
 *
 */

$.fn.bic_calendar = function(options) {

    var opts = $.extend({}, $.fn.bic_calendar.defaults, options);



    this.each(function() {


        /*** vars ***/


        //element called
        var elem = $(this);

        var calendar;
        var layoutMonth;
        var daysMonthsLayer;
        var textMonthCurrentLayer = $('<div class="visualmonth"></div>');
        var textYearCurrentLayer = $('<div class="visualyear"></div>');

        var calendarId = "bic_calendar";

        var events = opts.events;

        var dayNames;
        if (typeof opts.dayNames != "undefined")
            dayNames = opts.dayNames;
        else
            dayNames = ["S", "M", "T", "W", "T", "F", "S"];

        var monthNames;
        if (typeof opts.monthNames != "undefined")
            monthNames = opts.monthNames;
        else
            monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

        var showDays;
        if (typeof opts.showDays != "undefined")
            showDays = opts.showDays;
        else
            showDays = true;

        var popoverOptions;
        if (typeof opts.popoverOptions != "undefined")
            popoverOptions = opts.popoverOptions;
        else
            popoverOptions = {placement: 'bottom', html: true, trigger: 'hover'};

        var tooltipOptions;
        if (typeof opts.tooltipOptions != "undefined")
            tooltipOptions = opts.tooltipOptions;
        else
            tooltipOptions = {placement: 'bottom', trigger: 'hover'};

        var reqAjax;
        if (typeof opts.reqAjax != "undefined")
            reqAjax = opts.reqAjax;
        else
            reqAjax = false;

        var enableSelect = false;
        if (typeof opts.enableSelect != 'undefined')
            enableSelect = opts.enableSelect;

        var multiSelect = false;
        if (typeof opts.multiSelect != 'undefined')
            multiSelect = opts.multiSelect;

        var firstDaySelected = '';
        var lastDaySelected = '';
        var daySelected = '';

        /*** --vars-- ***/





        /*** functions ***/

        /**
         * init n print calendar
         */
        function showCalendar() {

            var newEventPane = $('<div id="new_event_pane" class="row" style="display:none;"></div>');

            //layer with the days of the month (literals)
            daysMonthsLayer = $('<div id="monthsLayer" class="row" style="height:300px;overflow-y:auto;"></div>');

            //Date obj to calc the day
            var objFecha = new Date();
            objFecha.setMonth(0);

            //current year
            var year = objFecha.getFullYear();

            //show the days of the month n year configured
            showMonths(year);

            //next-previous year controllers
            var nextYearButton = $('<td><a href="#" class="button-year-next"><i class="glyphicon glyphicon-arrow-right" ></i></a></td>');
            //event
            nextYearButton.click(function(e) {
                e.preventDefault();
                year++;
                changeDate(year);
            })
            var previousYearButton = $('<td><a href="#" class="button-year-previous"><i class="glyphicon glyphicon-arrow-left" ></i></a></td>');
            //event
            previousYearButton.click(function(e) {
                e.preventDefault();
                year--;
                changeDate(year);
            })


            //show the current year n current month text layer
            var headerLayer = $('<table class="table header"></table>');
            var yearTextLayer = $('<tr></tr>');
            var yearControlTextLayer = $('<td colspan=5 class="monthAndYear span6"></td>');

            yearTextLayer.append(previousYearButton);
            yearTextLayer.append(yearControlTextLayer);
            yearTextLayer.append(nextYearButton);
            yearControlTextLayer.append(textYearCurrentLayer);

            headerLayer.append(yearTextLayer);

            //calendar n border
            calendar = $('<div class="bic_calendar" id="' + calendarId + '" ></div>');
            calendar.prepend(headerLayer);
            //calendar.append(capaDiasSemana);
            //daysMonthLayer.prepend(capaDiasSemana);
            calendar.append(daysMonthsLayer);
            calendar.append(newEventPane);

            //insert calendar in the document
            elem.append(calendar);

            //check and add events
            checkEvents(year);

            //if enable select
            checkIfEnableMark();
        }

        /**
         * indeed, change month or year
         */
        function changeDate(year) {
            daysMonthsLayer.empty();
            showMonths(year);
            checkEvents(year);
            markSelectedDays();
        }

        /**
         * show literals of the week
         */
        function listListeralsWeek(month, year) {
            if (showDays != false) {
                var capaDiasSemana = $('<tr class="days-month">');
                var codigoInsertar = '';
                var firstDayMonth = calcNumberDayWeek(1, month, year);
                var lastDayMonth = lastDay(month, year);

                for(var i=0; i<38; i++) {
                  codigoInsertar += '<td';
                  if (i == 0) {
                      codigoInsertar += ' class="primero"';
                  }
                  if (i == 6) {
                      codigoInsertar += ' class="domingo ultimo"';
                  }

                  if(i < firstDayMonth || i-firstDayMonth >= lastDayMonth) {
                    codigoInsertar += '>&nbsp;</td>';
                  } else {
                    codigoInsertar += ">" + dayNames[i%7] + '</td>';
                  }
                }

                codigoInsertar += '</tr>';
                capaDiasSemana.append(codigoInsertar);

                layoutMonth.append(capaDiasSemana);
            }
        }

        /**
         * print months
         */
        function showMonths(year) {
            for (i = 0; i < 12; i++) {
                daysMonthsLayer.append($('</div><div class="row">'));
                showMonthDays(i, year);
            }
        }

        /**
         * show the days of the month
         */
        function showMonthDays(month, year) {

            //layoutMonth
            layoutMonth = $('<table class="table"></table>');

            //print year n month in layers
            textMonthCurrentLayer.text(monthNames[month]);
            textYearCurrentLayer.text(year);

            //show days of the month
            var daysCounter = 1;

            //calc the date of the first day of this month
            var firstDay = calcNumberDayWeek(1, month, year);

            //calc the last day of this month
            var lastDayMonth = lastDay(month, year);

            var nMonth = month + 1;

            var daysMonthLayerString = "";

            //print the days in the month
            for (var i = 0; i < 38; i++) {
              if(i === 0) {
                var dayCode = '<tr id="' + calendarId + '_' + year + '_' + nMonth + '">';

              }
              if (i < firstDay || i-firstDay >= lastDayMonth) {
                  var month_pos = (i < firstDay ? (i-firstDay) : (100+i));
                  //add weekDay
                  dayCode += '<td id="' + calendarId + '_' + year + '_' + nMonth + '_' + month_pos + '" class="invalid-day week-day-'+ i +'"';
                  dayCode += '><div>&nbsp;</div></td>';
              } else {
                  dayCode += '<td id="' + calendarId + '_' + year + "_" + nMonth + "_" + daysCounter + '" data-date="' + year + "/" + nMonth + "/" + daysCounter + '" ';
                  //add weekDay
                  dayCode += ' class="week-day-'+ i%7 +'"';
                  dayCode += '><div><a>' + daysCounter + '</a></div></td>';
                  daysCounter++;
              }
              if (i === 37) {
                dayCode += '</tr>';
              }

            }
            daysMonthLayerString += dayCode

            listListeralsWeek(month, year);

            layoutMonth.append(daysMonthLayerString);

            layoutMonth = $('<div class="monthDisplayed"></div>').append(layoutMonth);

            layoutMonth.prepend($('<div class="month">' + monthNames[month] + '</div>'));

            layoutMonth = $('<div class="col-md-12" style="padding:0px"></div>').append(layoutMonth);

            daysMonthsLayer.append(layoutMonth);
        }

        /**
         * calc the number of the week day
         */
        function calcNumberDayWeek(day, month, year) {
            var objFecha = new Date(year, month, day);
            var numDia = objFecha.getDay();
            if (numDia == 0)
                numDia = 6;
            else
                numDia--;
            return numDia;
        }

        /**
         * check if a date is correct
         *
         * @thanks http://kevin.vanzonneveld.net
         * @thanks http://www.desarrolloweb.com/manuales/manual-librerias-phpjs.html
         */
        function checkDate(m, d, y) {
            return m > 0 && m < 13 && y > 0 && y < 32768 && d > 0 && d <= (new Date(y, m, 0)).getDate();
        }

        /**
         * return last day of a date (month n year)
         */
        function lastDay(month, year) {
            var lastDayValue = 28;
            while (checkDate(month + 1, lastDayValue + 1, year)) {
                lastDayValue++;
            }
            return lastDayValue;
        }

        function validateWritedDate(fecha) {
            var arrayFecha = fecha.split(/\D/);
            if (arrayFecha.length != 3)
                return false;
            return checkDate(arrayFecha[1], arrayFecha[0], arrayFecha[2]);
        }

        function isLastDay(date) {
          return new Date(date.getTime() + 86400000).getDate() === 1;
        }

        /**
         * check if there are ajax events
         */
        function checkEvents(year) {
            if (reqAjax != false) {
                //peticio ajax
                $.ajax({
                    type: reqAjax.type,
                    url: reqAjax.url,
                    data: {ano: year},
                    dataType: 'json'
                }).done(function(data) {

                    if (typeof events == 'undefined')
                        events = [];

                    $.each(data, function(k, v) {
                        events.push(data[k]);
                    });

                    markEvents(year);

                });
            } else {
                markEvents(year);
            }
        }

        /**
         * mark all the events n create logic for them
         */
        function markEvents(year) {
            for (var i = 0; i < events.length; i++) {
              if(events[i].type == "rent_payment") {
                var eventDate = new Date(events[i].date);
                var eventDiv = $('#bic_calendar_' + eventDate.getFullYear() + '_' + (parseInt(eventDate.getMonth()) + 1) + '_' + eventDate.getDate() + ' div');
                eventDiv.addClass('payment event_popover');
                eventDiv.find('a').attr('href', events[i].link);
                eventDiv.find('a').attr('rel', 'popover');
                eventDiv.find('a').attr('data-content', events[i].content);
              } else {

                if(!events[i].date_to) {
                  events[i].date_to = events[i].date;
                }

                if (events[i].date.split(/\D/)[0] == year || events[i].date_to.split(/\D/)[0] == year) {

                  //create date object from dates
                  var fromDate = new Date(events[i].date);
                  var toDate = new Date(events[i].date_to);


                  //create a loop adding day per loop to set days
                  //turn dates if >
                  if (fromDate > toDate) {
                      //turn vars date
                      var tempDate = fromDate;
                      fromDate = toDate;
                      toDate = tempDate;
                  }

                  currDate = new Date(fromDate);

                  //set first selection
                  while (currDate <= toDate) {

                    var $currDay = $('#bic_calendar_' + currDate.getFullYear() + '_' + (parseInt(currDate.getMonth()) + 1) + '_' + currDate.getDate());
                    var $currDayDiv = $currDay.children('div');
                    var $currDayA = $currDayDiv.children('a');
                    if(currDate.toString().slice(0, 15) == fromDate.toString().slice(0, 15)) {

                      // Set first selection
                      $currDayDiv.addClass('snapshot first-selection');
                    }
                    if(currDate.toString().slice(0, 15) == toDate.toString().slice(0, 15)) {
                      // Set last selection
                      $currDayDiv.addClass('snapshot last-selection');
                    }

                    if(currDate.toString().slice(0, 15) != fromDate.toString().slice(0, 15) && currDate.toString().slice(0, 15) != toDate.toString().slice(0, 15)) {
                      //set middle-selection
                      $currDayDiv.addClass('snapshot middle-selection');

                      if(currDate.getDate() === 1) {
                        $currDayDiv.removeClass('middle-selection');
                        $currDayDiv.addClass('first-selection');
                    //    var firstIndex = $('#bic_calendar_' + currDate.getFullYear() + '_' + (parseInt(currDate.getMonth()) + 1) + '_' + currDate.getDate()).index();
                    //    $('#bic_calendar_' + currDate.getFullYear() + '_' + (parseInt(currDate.getMonth()) + 1) + ' td:lt(' + (firstIndex) + ') div').addClass('snapshot middle-selection');
                    //    loopDayDiv = $('#bic_calendar_' + currDate.getFullYear() + '_' + (parseInt(currDate.getMonth()) + 1) + ' td:lt(' + (firstIndex+1) + ') div');
                    //    loopDayA = $('#bic_calendar_' + currDate.getFullYear() + '_' + (parseInt(currDate.getMonth()) + 1) + ' td:lt(' + (firstIndex+1) + ') a');
                      }

                      if(isLastDay(currDate)) {
                        $currDayDiv.removeClass('middle-selection');
                        $currDayDiv.addClass('last-selection');
                    //    var lastIndex = $('#bic_calendar_' + currDate.getFullYear() + '_' + (parseInt(currDate.getMonth()) + 1) + '_' + currDate.getDate()).index();
                    //    $('#bic_calendar_' + currDate.getFullYear() + '_' + (parseInt(currDate.getMonth()) + 1) + ' td:gt(' + (lastIndex) + ') div').addClass('snapshot middle-selection');
                    //    loopDayDiv = $('#bic_calendar_' + currDate.getFullYear() + '_' + (parseInt(currDate.getMonth()) + 1) + ' td:gt(' + (lastIndex-1) + ') div');
                    //    loopDayA = $('#bic_calendar_' + currDate.getFullYear() + '_' + (parseInt(currDate.getMonth()) + 1) + ' td:gt(' + (lastIndex-1) + ') a');
                      }
                    }

                    //bg color
                    if (events[i].color) {
                        var r = parseInt(events[i].color.slice(1,3), 16);
                        var g = parseInt(events[i].color.slice(3,5), 16);
                        var b = parseInt(events[i].color.slice(5,7), 16);
                        $currDayDiv.css('background', `rgba(${r}, ${g}, ${b}, 0.5)`);
                    }

                    //link
                    if (events[i].link) {
                        $currDayA.attr('href', events[i].link);
                    }

                    //class
                    if (events[i].class)
                        $currDayDiv.addClass(events[i].class);

                    //tooltip vs popover
                    if(!$currDayDiv.hasClass('event_popover') && !$currDayDiv.hasClass('event_tooltip')) {
                      $currDayA.attr('data-original-title', events[i].title);

                      if (events[i].content) {
                          $currDayDiv.addClass('event_popover');
                          $currDayA.attr('rel', 'popover');
                          $currDayA.attr('data-content', events[i].content);
                      } else {
                          $currDayDiv.addClass('event_tooltip');
                          $currDayA.attr('rel', 'tooltip');
                      }
                    }

                    currDate.setDate(currDate.getDate() + 1);
                  }
                }
              }
            }

            $('#' + calendarId + ' ' + '.event_tooltip a').tooltip(tooltipOptions);
            $('#' + calendarId + ' ' + '.event_popover a').popover(popoverOptions);

            $('.manual_popover').click(function() {
                $(this).popover('toggle');
            });
        }

        /**
         * check if the user can mark days
         */
        function checkIfEnableMark() {
            if (enableSelect == true) {

                var eventBicCalendarSelect;

                elem.on('click', '#monthsLayer td', function() {
                    if(!$(this).find('div').hasClass('snapshot')) {
                      //if multiSelect
                      if (multiSelect == true) {
                          if (daySelected == '') {
                              daySelected = $(this).data('date');
                              markSelectedDays();
                          } else {
                              if (lastDaySelected == '') {
                                  //set firstDaySelected
                                  firstDaySelected = daySelected;
                                  lastDaySelected = $(this).data('date');

                                  markSelectedDays();

                                  //create n fire event
                                  //to change
                                  var eventBicCalendarSelect = new CustomEvent("bicCalendarSelect", {
                                      detail: {
                                          dateFirst: firstDaySelected,
                                          dateLast: lastDaySelected
                                      }
                                  });
                                  document.dispatchEvent(eventBicCalendarSelect);
                              } else {
                                  elem.find('.selection').removeClass('middle-selection selection first-selection last-selection');
                                  markEvents(firstDaySelected.split(/\D/)[0]);
                                  firstDaySelected = '';
                                  lastDaySelected = '';
                                  daySelected = '';
                                  $('#new_snapshot_pane').hide();
                                  $('.bic_calendar a').css('cursor', 'pointer');

                              }
                          }
                      } else {
                          //remove the class selection of the others a
                          elem.find('td div').removeClass('selection');
                          //add class selection
                          $(this).find('div').addClass('selection');
                          //create n fire event
                          var eventBicCalendarSelect = new CustomEvent("bicCalendarSelect", {
                              detail: {
                                  date: $(this).data('date')
                              }
                          });
                          document.dispatchEvent(eventBicCalendarSelect);
                      }
                    }
                })
            }
        }

        /**
         * to mark selected dates
         */
        function markSelectedDays() {
            if (daySelected != '' && firstDaySelected == '') {
                var arrayDate = daySelected.split(/\D/);
                $('#bic_calendar_' + arrayDate[0] + '_' + arrayDate[1] + '_' + arrayDate[2] + ' div').addClass('selection');
            } else if (firstDaySelected != '') {
                //create array from dates
                var arrayFirstDay = firstDaySelected.split(/\D/);
                var arrayLastDay = lastDaySelected.split(/\D/);

                //remove all selected classes
                elem.find('.selection').removeClass('selection');

                //create date object from dates
                var firstSelectedDate = new Date(firstDaySelected);
                var lastSelectedDate = new Date(lastDaySelected);

                //create a loop adding day per loop to set days
                //turn dates if >
                if (firstSelectedDate > lastSelectedDate) {
                    //turn vars date
                    var backwards = true;
                }
                var currDate = new Date(firstDaySelected);
                var addClass = "";
                var removeClass = "";

                while ((!backwards && currDate <= lastSelectedDate) ||
                      (backwards && currDate >= lastSelectedDate)) {
                  addClass = "selection";

                  if($('#bic_calendar_' + currDate.getFullYear() + '_' + (parseInt(currDate.getMonth()) + 1) + '_' + currDate.getDate() + ' div').hasClass('snapshot')) {
                    if(!backwards) {
                      currDate.setDate(currDate.getDate() - 1);
                    } else {
                      currDate.setDate(currDate.getDate() + 1);
                    }
                    lastSelectedDate = new Date(currDate.toString());
                    removeClass = 'middle-selection';
                  }

                  if(currDate.toString().slice(0, 15) == firstSelectedDate.toString().slice(0, 15)) {
                    if(!backwards) {
                      addClass += ' first-selection';
                    } else {
                      addClass += ' last-selection';
                    }

                  }

                  if(currDate.toString().slice(0, 15) == lastSelectedDate.toString().slice(0, 15)) {
                    if(!backwards) {
                      addClass += ' last-selection';
                    } else {
                      addClass += ' first-selection';
                    }
                  }

                  if(currDate.toString().slice(0, 15) != firstSelectedDate.toString().slice(0, 15) && currDate.toString().slice(0, 15) != lastSelectedDate.toString().slice(0, 15)) {
                    addClass += ' middle-selection';
                    //set middle-selection
                  }
                  $('#bic_calendar_' + currDate.getFullYear() + '_' + (parseInt(currDate.getMonth()) + 1) + '_' + currDate.getDate() + ' div').addClass(addClass);
                  $('#bic_calendar_' + currDate.getFullYear() + '_' + (parseInt(currDate.getMonth()) + 1) + '_' + currDate.getDate() + ' div').removeClass(removeClass);

                  if(backwards) {
                    currDate.setDate(currDate.getDate() - 1);
                  } else {
                    currDate.setDate(currDate.getDate() + 1);
                  }

                }
                $('#bic_calendar #monthsLayer a').css('cursor', 'default');

                if(!backwards) {
                  addNewSnapshot(firstSelectedDate, lastSelectedDate);
                } else {
                  addNewSnapshot(lastSelectedDate, firstSelectedDate);
                }
            }
        }

        function addNewSnapshot(date_from, date_to) {
          $('#new_snapshot_pane [id$="start_date"]').val(`${date_from.getFullYear()}-${date_from.getMonth()+1}-${date_from.getDate()}`);
          $('#new_snapshot_pane [id$="end_date"]').val(`${date_to.getFullYear()}-${date_to.getMonth()+1}-${date_to.getDate()}`);
          $('#new_snapshot_pane').slideDown('slow');
        }

        /*** --functions-- ***/



        //fire calendar!
        elem.empty();
        showCalendar();


    });
    return this;
};
