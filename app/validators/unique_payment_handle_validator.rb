class UniquePaymentHandleValidator < ActiveModel::EachValidator

  # Validates that the unique reference each tenant has is not duplicated with another tenant
  def validate_each(new_tenant, attribute, value)

    tenants = Tenant.current
    tenants.each do |existing_tenant|
      next if existing_tenant.id == new_tenant.id || existing_tenant.payment_handle.blank? || new_tenant.payment_handle.blank?

      if existing_tenant.payment_handle.downcase.include?(new_tenant.payment_handle.downcase) || new_tenant.payment_handle.downcase.include?(existing_tenant.payment_handle.downcase)
        new_tenant.errors[:payment_handle] << " clashes with existing payment handle: (<strong><em>#{new_tenant.payment_handle}</em></strong> & <strong><em>#{existing_tenant.payment_handle}<em></strong>)"
        break
      end
    end
  end
end
