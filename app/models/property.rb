class Property < ApplicationRecord
  has_many :property_snapshots
  has_many :tenants, through: :property_snapshots

  validates_length_of :name, minimum: 3, allow_blank: false
  validates_length_of :address, minimum: 10, allow_blank: false
  validates_uniqueness_of :name, :address

  def self.archived
    return Property.all.where(archived: true)
  end

  def self.current
    return Property.all.where(archived: false)
  end

  def current_tenants
    latest_p_snapshot = self.property_snapshots.order(:start_date).last

    if latest_p_snapshot.nil?
      return nil
    else
      curr_tenants = Array.new
      latest_p_snapshot.tenant_snapshots.where("end_date IS NULL OR end_date = ?", Date.today).each do |t_snapshot|
        curr_tenants.push t_snapshot.tenant
      end
      return curr_tenants
    end
  end
end
