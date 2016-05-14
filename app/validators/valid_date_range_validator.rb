class ValidDateRangeValidator < ActiveModel::Validator
   def validate(record)

    # Specify the model (i.e. 'property' or 'tenant') to only compare dates with a specific tenant or property,
    #  rather than all tenants or properties (i.e. different tenants can have overlapping date ranges)
    if options[:model]
      id = record.send("#{options[:model]}_id")
      snapshots = record.class.name.constantize.send("all").where("#{options[:model]}_id = #{id}")
    else
      snapshots = record.class.name.constantize.send("all")
    end

    # Jump out of validator if start date hasn't been set
    record.start_date.nil? ? (return false) : ""

    snapshots.each do |ss|
      # Validate start date to make sure it doesn't clash with existing date range
      if record.start_date >= ss.start_date && record.start_date <= ss.end_date
        record.errors[:base] << "Start date: <b><i>(#{record.start_date_str})</b></i> falls within existing date range: <b><i>(#{ss.start_date_str} - #{ss.end_date_str})</b></i>"
        break
      end

      # Validate end date to make sure it doesn't clash with existing date range
      if record.end_date >= ss.start_date && record.end_date <= ss.end_date
        record.errors[:base] << "End date: <b><i>(#{record.end_date_str})</b></i> falls within existing date range: <b><i>(#{ss.start_date_str} - #{ss.end_date_str})</b></i>"
        break
      end

      # Validate start and end date to ensure that an existing date range doesn't lie within this date range
      if record.start_date < ss.start_date && record.end_date > ss.end_date
        record.errors[:base] << "Submitted date range clashes with existing date range: <b><i>(#{ss.start_date_str} - #{ss.end_date_str})</b></i>"
        break
      end

      # Validate to make sure that the start date comes before the end date
      if record.start_date >= record.end_date
        record.errors[:base] << "Start date: <b><i>(#{record.start_date_str})</b></i> must be earlier than the end date: <b><i>(#{record.end_date_str})</b></i>"
        break
      end
    end
  end
end
