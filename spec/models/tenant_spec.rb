# spec/models/tenant_spec.rb
require 'spec_helper'

describe Tenant do
  it "has a valid factory" do
    expect(FactoryGirl.create(:tenant)).to be_valid
  end

  # Name tests
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

  # Payment Handle tests
  it "is only valid if payment_handle is 5 or more chars long" do
    expect(FactoryGirl.build(:tenant, payment_handle: "PAYM")).to_not be_valid
    expect(FactoryGirl.build(:tenant, payment_handle: "PAYME")).to be_valid
  end
  it "is only valid if payment_handle doesn't clash with existing payment_handle" do
    expect(FactoryGirl.create(:tenant, payment_handle: "TEST1")).to be_valid
    expect(FactoryGirl.build(:tenant, payment_handle: "TEST123")).to_not be_valid
    expect(FactoryGirl.build(:tenant, payment_handle: "test123")).to_not be_valid
  end

  # Phone number tests
  it "is only valid if phone number is 5 or more chars long" do
    expect(FactoryGirl.build(:tenant, phone_num: "0123")).to_not be_valid
    expect(FactoryGirl.build(:tenant, phone_num: "01234")).to be_valid
  end
  it "is only valid if phone number is in valid format (i.e. no [a-z] chars (except x))" do
    expect(FactoryGirl.build(:tenant, phone_num: "+44(1422)-345-345")).to be_valid
    expect(FactoryGirl.build(:tenant, phone_num: "+44(phone)1234")).to_not be_valid
  end

  # Email address tests
  it "is only valid if email address is in a valid format" do
    expect(FactoryGirl.build(:tenant, email: "harry123@comcast.net")).to be_valid
    expect(FactoryGirl.build(:tenant, email: "b@b.co")).to be_valid
    expect(FactoryGirl.build(:tenant, email: "b@b")).to_not be_valid
  end

  # House id tests
  it "is only valid if house_id matches existing house" do
    expect(FactoryGirl.create(:house)).to be_valid
    house_id = House.first.id
    expect(FactoryGirl.create(:tenant, house_id: house_id)).to be_valid
    expect{FactoryGirl.create(:tenant, house_id: house_id+1)}.to raise_error(ActiveRecord::RecordInvalid)
  end
end
