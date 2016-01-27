class ValidDateRangeValidator < ActiveModel::Validator
   def validate(record)
    snapshots = record.class.name.constantize.send("all")

    snapshots.each do |ss|
      if record.start_date >= ss.start_date && record.start_date <= ss.end_date
        record.errors[:base] << "Start date: <b><i>(#{record.start_date_str})</b></i> falls within existing date range: <b><i>(#{ss.start_date_str} - #{ss.end_date_str})</b></i>"
        break
      end

      if record.end_date >= ss.start_date && record.end_date <= ss.end_date
        record.errors[:base] << "End date: <b><i>(#{record.end_date_str})</b></i> falls within existing date range: <b><i>(#{ss.start_date_str} - #{ss.end_date_str})</b></i>"
        break
      end

      if record.start_date < ss.start_date && record.end_date > ss.end_date
        record.errors[:base] << "Submitted date range clashes with existing date range: <b><i>(#{ss.start_date_str} - #{ss.end_date_str})</b></i>"
        break
      end

      if record.start_date >= record.end_date
        record.errors[:base] << "Start date: <b><i>(#{record.start_date_str})</b></i> must be earlier than the end date: <b><i>(#{record.end_date_str})</b></i>"
        break
      end
    end
  end
end