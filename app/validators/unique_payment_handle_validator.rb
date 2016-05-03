class UniquePaymentHandleValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    tenants = Tenant.all
    tenants.each do |t|
      next if t.id == record.id
      if t.payment_handle.include?(record.payment_handle) || record.payment_handle.include?(t.payment_handle)
        record.errors[:base] << "Submitted Payment Handle clashes with existing payment handle (<b><i>#{record.payment_handle}</b></i> & <b><i>#{t.payment_handle}</b></i>)"
        break
      end
    end
  end
end