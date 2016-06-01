class SnapshotDateRangeValidator < ActiveModel::Validator
  def validate(ss)

    # Specify the model (i.e. 'property' or 'tenant') to only compare dates with a specific tenant or property,
    #  rather than all tenants or properties (i.e. different tenants can have overlapping date ranges)
    if options[:model]
      id = ss.send("#{options[:model]}_id")
      snapshots = ss.class.name.constantize.send("all").where("#{options[:model]}_id = ?", id)
    else
      snapshots = ss.class.name.constantize.send("all")
    end

    # Jump out of validator if start date hasn't been set
    ss.start_date.nil? ? (return false) : ""

    snapshots.each do |existing_ss|
      # Validate to make sure that the start date comes before the end date
      if ss.start_date >= ss.end_date
        ss.errors[:base] << "<br />The start date must be an earlier date than the end date"
        break
      end

      # Validate start and end date to ensure that an existing date range doesn't lie within this date range
      if (ss.start_date < existing_ss.start_date && ss.end_date > existing_ss.end_date ||
          ss.end_date >= existing_ss.start_date && ss.end_date <= existing_ss.end_date ||
          ss.start_date >= existing_ss.start_date && ss.start_date <= existing_ss.end_date)
          ss.errors[:base] << "<br />Snapshot clashes with existing snapshot: <strong><em>#{existing_ss.name}</strong></em>"
        break
      end
    end
  end
end
