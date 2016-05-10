module TenantsHelper
  def draw_timeline_old
    html_str = "<style>
                  .timeline {
                    width:150px;
                    margin:0px 50px;
                    border:1px solid #000000;
                    border-width: 0px 2px;
                  }
                </style>

                "

    i = 1
    cur_date = @sorted_snapshots.first.start_date

    bgcolor = "#f0f0f0"
    cur_snapshot = 0

    # Loop up through months
    while cur_date <= @sorted_snapshots.last.end_date

      borders = Array.new
      gradient_str = bgcolor + ", "



      html_str += '<div class="timeline" style="'
      html_str += 'height: ' + (cur_date.end_of_month.day * 5).to_s + 'px; '
      html_str += 'background-image: linear-gradient(red 0%, red 30px, gray 30px, gray 60px, red 60px, red 100%); '
      html_str += 'background-image: -webkit-linear-gradient(red 0%, red 30px, gray 30px, gray 60px, red 60px, red 100%);'
      html_str += '">'
      html_str += cur_date.strftime('%b %Y')
      html_str += '</div>'

      # Increment by 1 month
      cur_date = cur_date >> 1
    end

    return html_str.html_safe
  end

  def draw_timeline
    html_str = "<style>
                  .timeline {
                    width:80px;
                    margin:0px 50px;
                    border:1px solid #000000;
                    border-width: 0px 2px;
                  }
                  .timeline:first-child {
                    border-width: 2px 2px 0px 2px;
                  }
                  .timeline:last-child {
                    border-width: 0px 2px 2px 2px;
                  }
                </style>
                <div>
                "


    bgcolors = ['#f0f0f0', '#666666']
    @sorted_snapshots.each_with_index do |ss, i|
      html_str += '<div class="timeline" style="'
      html_str += 'height: ' + (ss.length_in_days * 3).to_s + 'px; '
      html_str += 'background-color: ' + bgcolors[i%2] + ';'
      html_str += '">'
      html_str += ss.start_date_str
      html_str += '</div>'
    end

    html_str += "</div"
    return html_str.html_safe
  end
end
