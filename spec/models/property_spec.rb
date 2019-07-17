# spec/models/property_spec.rb
require 'spec_helper'

describe "Tests for Property model" do
  context "Checking Factory" do
    it "has a valid factory" do
      expect(FactoryBot.create(:property)).to be_valid
    end
  end

  context "Testing Name validation" do
    it "is invalid without a name" do
      expect(FactoryBot.build(:property, name: nil)).to_not be_valid
    end
    it "is invalid if the name is less than 3 chars long" do
      expect(FactoryBot.build(:property, name: "NYC")).to be_valid
      expect(FactoryBot.build(:property, name: "NY")).to_not be_valid
    end
    it "is invalid if the name isn't unique" do
      expect(FactoryBot.create(:property, name: "Test Name")).to be_valid
      expect(FactoryBot.build(:property, name: "Test Name")).to_not be_valid
      expect(FactoryBot.build(:property, name: "Test Name1")).to be_valid
    end
  end

  context "Testing Address validation" do
    it "is invalid without an address" do
      expect(FactoryBot.build(:property, address: nil)).to_not be_valid
    end
    it "is invalid if the address is less than 10 chars long" do
      expect(FactoryBot.build(:property, address: "1234567890")).to be_valid
      expect(FactoryBot.build(:property, address: "123456789")).to_not be_valid
    end
    it "is invalid if the address isn't unique" do
      expect(FactoryBot.create(:property, address: "123 Test Road")).to be_valid
      expect(FactoryBot.build(:property, address: "123 Test Road")).to_not be_valid
      expect(FactoryBot.build(:property, address: "124 Test Road")).to be_valid
    end
  end
end
