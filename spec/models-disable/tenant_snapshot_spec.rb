# spec/models/tenant_snapshot_spec.rb
require 'spec_helper'

describe "Tests for TenantSnapshot model" do
  context "Checking Factory" do
    it "has a valid factory" do
      ts = FactoryGirl.build(:tenant_snapshot)
      byebug
      expect(ts).to be_valid
    end
  end

  context "Testing Dates validation" do
    it "is invalid without a start date"
  end
end