class PropertySnapshot < ApplicationRecord
  include ModelHelpers

  belongs_to :property
  has_many :snapshot_joins
  has_many :tenant_snapshots, through: :snapshot_joins
  has_many :tenants, through: :tenant_snapshots

  validates :property, :start_date, presence: true

  validates_with SnapshotDateRangeValidator, model: "property"

  ### MOVE BELOW METHODS TO HELPER MODULE????? ###

  # This method looks to see if there is a continuous unbroken flow of dates over one of more
  #  snapshots
  # If there is, then it returns the id's of the snapshots that the date range covers
  def self.date_range_exists?(model: model, model_id: model_id, start_date: start_date, end_date: end_date)
    id_field = model.downcase + "_id"
    snapshot_model = model.capitalize + "Snapshot"

    # Get a list of snapshots that match the passed snapshot
    # i.e. A snapshot from 10th May - 15th May will match an existing snapshot going from 1st May - 31st May
    matching_snapshots = snapshot_model.constantize.where("#{id_field} = ?", model_id)
                                                   .where('start_date <= ?', end_date)
                                                   .where('end_date >= ? OR end_date IS NULL', start_date)
                                                   .order(:start_date)

    if matching_snapshots.length == 0
      return false
    elsif self.snapshots_continuous?(matching_snapshots)
      return matching_snapshots
    else
      return false
    end
  end

  # Returns true if snapshots are continous set of dates (ie. no gaps between them)
  def self.snapshots_continuous?(snapshots)
    if snapshots.length < 2
      return true
    end

    prev_ss_end = snapshots.first.end_date
    snapshots.each_with_index do |ss, i|
      next if i == 0
      return false if (ss.start_date - prev_ss_end).to_i > 1   # If gap between two snapshots is more than 1 day, return false
      prev_ss_end = ss.end_date
    end
    return true
  end

  def total_rent_expected
    return (self.weekly_rent/7)*self.length_in_days
  end
end
