# spec/models/tenant_spec.rb
require 'spec_helper'

describe "Tests for Tenant validation" do
  context "Checking Factory" do
    it "has a valid factory" do
      expect(FactoryGirl.create(:tenant)).to be_valid
    end
  end

  context "Testing Name validation" do
    it "is invalid without a name" do
      expect(FactoryGirl.build(:tenant, name: nil)).to_not be_valid
    end
    it "is only valid if name is 4 or more chars long" do
      expect(FactoryGirl.build(:tenant, name: "Pete")).to be_valid
      expect(FactoryGirl.build(:tenant, name: "Chr")).to_not be_valid
    end
    it "is only valid if name is unique" do
      expect(FactoryGirl.create(:tenant, name: "Test Name")).to be_valid
      expect(FactoryGirl.build(:tenant, name: "Test Name")).to_not be_valid
      expect(FactoryGirl.build(:tenant, name: "Test Name1")).to be_valid
    end
  end

  context "Testing Payment Handle validation" do
    it "is only valid if payment_handle is 5 or more chars long" do
      expect(FactoryGirl.build(:tenant, payment_handle: "PAYM")).to_not be_valid
      expect(FactoryGirl.build(:tenant, payment_handle: "PAYME")).to be_valid
    end
    it "is only valid if payment_handle doesn't clash with existing payment_handle" do
      expect(FactoryGirl.create(:tenant, payment_handle: "TEST1")).to be_valid
      expect(FactoryGirl.build(:tenant, payment_handle: "TEST123")).to_not be_valid
      expect(FactoryGirl.build(:tenant, payment_handle: "test123")).to_not be_valid
    end
  end

  context "Testing Phone number validation" do
    it "is only valid if phone number is 5 or more chars long" do
      expect(FactoryGirl.build(:tenant, phone_num: "0123")).to_not be_valid
      expect(FactoryGirl.build(:tenant, phone_num: "01234")).to be_valid
    end
    it "is only valid if phone number is in valid format (i.e. no [a-z] chars (except x))" do
      expect(FactoryGirl.build(:tenant, phone_num: "+44(1422)-345-345")).to be_valid
      expect(FactoryGirl.build(:tenant, phone_num: "+44(phone)1234")).to_not be_valid
    end
  end

  context "Testing Email address validation" do
    it "is only valid if email address is in a valid format" do
      expect(FactoryGirl.build(:tenant, email: "harry123@comcast.net")).to be_valid
      expect(FactoryGirl.build(:tenant, email: "b@b.co")).to be_valid
      expect(FactoryGirl.build(:tenant, email: "b@b")).to_not be_valid
    end
  end

  context "Testing Property ID validation" do
    it "is only valid if property_id matches existing property" do
      expect(FactoryGirl.create(:property)).to be_valid
      property_id = Property.last.id
      expect(FactoryGirl.create(:tenant, property_id: property_id)).to be_valid
      expect{FactoryGirl.create(:tenant, property_id: property_id+1)}.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
