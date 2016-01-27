class ValidDateRangeValidator < ActiveModel::Validator
   def validate(record)
    snapshots = record.class.name.constantize.send("all")

    r_start_str = record.start_date.strftime('%d %b %Y')
    r_end_str = record.end_date.strftime('%d %b %Y')

    snapshots.each do |ss|

      ss_start_str = ss.start_date.strftime('%d %b %Y')
      ss_end_str = ss.end_date.strftime('%d %b %Y')

      if record.start_date >= ss.start_date && record.start_date <= ss.end_date
        record.errors[:base] << "Start date: <b><i>(#{r_start_str})</b></i> falls within existing date range: <b><i>(#{ss_start_str} - #{ss_end_str})</b></i>"
        break
      end

      if record.end_date >= ss.start_date && record.end_date <= ss.end_date
        record.errors[:base] << "End date: <b><i>(#{r_end_str})</b></i> falls within existing date range: <b><i>(#{ss_start_str} - #{ss_end_str})</b></i>"
        break
      end

      if record.start_date < ss.start_date && record.end_date > ss.end_date
        record.errors[:base] << "Submitted date range clashes with existing date range: <b><i>(#{ss_start_str} - #{ss_end_str})</b></i>"
        break
      end

      if record.start_date >= record.end_date
        record.errors[:base] << "Start date: <b><i>(#{r_start_str})</b></i> must be earlier than the end date: <b><i>(#{r_end_str})</b></i>"
        break
      end
    end
  end
end