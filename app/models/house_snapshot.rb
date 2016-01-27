class HouseSnapshot < ActiveRecord::Base
  belongs_to :house

  validates_associated :house

  validates :house, :start_date, presence: true

  validates_with ValidDateRangeValidator

  def end_date
    if self[:end_date].nil?
      return Date.today
    else
      return self[:end_date]
    end
  end
  def end_date_str
    if self[:end_date].nil?
      return "ongoing"
    else
      return self[:end_date].strftime('%d %b %Y')
    end
  end
  def start_date_str
    return self[:start_date].strftime('%d %b %Y')
  end
end
