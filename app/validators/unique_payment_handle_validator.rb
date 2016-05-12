class UniquePaymentHandleValidator < ActiveModel::EachValidator

  # Validates that the unique reference each tenant has is not duplicated with another tenant
  def validate_each(record, attribute, value)

    tenants = Tenant.all
    tenants.each do |t|
      next if t.id == record.id || t.payment_handle.blank? || record.payment_handle.blank?
      if t.payment_handle.downcase.include?(record.payment_handle.downcase) || record.payment_handle.downcase.include?(t.payment_handle.downcase)
        record.errors[:payment_handle] << " clashes with existing payment handle (<b><i>#{record.payment_handle}</b></i> & <b><i>#{t.payment_handle}</b></i>)"
        break
      end
    end
  end
end
