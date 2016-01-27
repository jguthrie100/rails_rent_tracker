module ModelHelpers
  
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
      return date_str self[:end_date]
    end
  end

  def start_date_str
    return date_str self[:start_date]
  end

  def date_str
    return date_str self[:date]
  end

  def date_str(date)
    return date.strftime('%d %b %Y')
  end

  def amount_str
    return ActionController::Base.helpers.number_to_currency(self[:amount], :unit => "$")
  end
end