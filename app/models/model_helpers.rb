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

  def date_str(date = self[:date])
    if date.nil?
      return 'nil'
    end

    return date.strftime('%d %b %Y')
  end

  def amount_str
    return ActionController::Base.helpers.number_to_currency(self[:amount], :unit => "$")
  end

  def length_in_days
    # Throw exception if start_date is not set or is of invalid type
    if self[:start_date].nil? || (self[:start_date].class != Time && self[:start_date].class != Date)
      raise "Exception: Calling object requires a valid .start_date property"
    end

    return (end_date - self[:start_date]).to_i + 1
  end

  def name
    case self.class.to_s
    when "Transaction"
      return self[:transaction_id]
    when "PropertySnapshot"
      return "#{property.name} (#{start_date_str} - #{end_date_str})"
    when "TenantSnapshot"
      return "#{tenant.name} (#{start_date_str} - #{end_date_str})"
    end
  end
end
