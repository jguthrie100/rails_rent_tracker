# spec/models/house_spec.rb
require 'spec_helper'

describe "Tests for House model" do
  context "Checking Factory" do
    it "has a valid factory" do
      expect(FactoryGirl.create(:house)).to be_valid
    end
  end

  context "Testing Name validation" do
    it "is invalid without a name" do
      expect(FactoryGirl.build(:house, name: nil)).to_not be_valid
    end
    it "is invalid if the name is less than 3 chars long" do
      expect(FactoryGirl.build(:house, name: "NYC")).to be_valid
      expect(FactoryGirl.build(:house, name: "NY")).to_not be_valid
    end
    it "is invalid if the name isn't unique" do
      expect(FactoryGirl.create(:house, name: "Test Name")).to be_valid
      expect(FactoryGirl.build(:house, name: "Test Name")).to_not be_valid
      expect(FactoryGirl.build(:house, name: "Test Name1")).to be_valid
    end
  end

  context "Testing Address validation" do
    it "is invalid without an address" do
      expect(FactoryGirl.build(:house, address: nil)).to_not be_valid
    end
    it "is invalid if the address is less than 10 chars long" do
      expect(FactoryGirl.build(:house, address: "1234567890")).to be_valid
      expect(FactoryGirl.build(:house, address: "123456789")).to_not be_valid
    end
    it "is invalid if the address isn't unique" do
      expect(FactoryGirl.create(:house, address: "123 Test Road")).to be_valid
      expect(FactoryGirl.build(:house, address: "123 Test Road")).to_not be_valid
      expect(FactoryGirl.build(:house, address: "124 Test Road")).to be_valid
    end
  end
end
