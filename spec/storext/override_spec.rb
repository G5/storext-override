require 'spec_helper'

describe Storext::Override do

  it "does not inherit attribute defaults and returns the parent's attribute value" do
    computer = Komputer.create(manufacturer: "not default")
    phone = Phone.create(computer: computer)
    expect(phone.manufacturer).to eq "not default"

    computer.update_attributes(manufacturer: "Compaq")
    expect(phone.manufacturer).to eq "Compaq"
  end

  it "overrides the parent" do
    computer = Komputer.create(manufacturer: "Dell")
    phone = Phone.create(computer: computer, manufacturer: "Compaq")
    expect(phone.manufacturer).to eq "Compaq"
  end

  it "can override the parent using `nil`" do
    computer = Komputer.create(manufacturer: "Dell")
    phone = Phone.create(computer: computer, manufacturer: nil)
    expect(phone.manufacturer).to be_nil
  end

  context "override_* is falsey (except nil)" do
    let(:computer) { Komputer.create(manufacturer: "Dell") }
    let(:phone) { Phone.create(computer: computer, manufacturer: "Compaq") }
    subject { phone.manufacturer }

    before do
      phone.update_attributes({
        override_manufacturer: override_manufacturer,
        manufacturer: "Doesn't matter",
      })
    end

    context "override is `false`" do
      let(:override_manufacturer) { false }
      it { is_expected.to eq "Dell" }
    end

    context "override is `'0'`" do
      let(:override_manufacturer) { '0' }
      it { is_expected.to eq "Dell" }
    end

    context "override is `0`" do
      let(:override_manufacturer) { 0 }
      it { is_expected.to eq "Dell" }
    end
  end

  context "override_* is falsey" do
    it "removes the manufacturer key, agnostic to the order of the keys, so the overrider defaults to the parent" do
      computer = Komputer.create(manufacturer: "Dell")
      phone = Phone.create(computer: computer, manufacturer: "Compaq")

      phone.update_attributes({
        manufacturer: "Doesn't matter",
        override_manufacturer: false,
      })

      expect(phone.data).to_not have_key(:manufacturer)
      expect(phone.manufacturer).to eq "Dell"
    end
  end

  context "override_* is true" do
    it "ensures sets the manufacturer key" do
      computer = Komputer.create(manufacturer: "Dell")
      phone = Phone.create(computer: computer, manufacturer: "Compaq")

      phone.update_attributes({
        manufacturer: "Matters",
        override_manufacturer: true,
      })

      expect(phone.manufacturer).to eq "Matters"
    end
  end

  context "override_* when the association it belongs to is nil" do
    subject { Phone.new.manufacturer }
    it { is_expected.to be_nil }
  end

  context "reading override_*" do
    let(:computer) { Komputer.create(manufacturer: "Dell") }
    subject { phone.override_manufacturer }

    context "the key exists" do
      let(:phone) { Phone.create(computer: computer, manufacturer: "Compaq") }
      it { is_expected.to be true }
    end

    context "the key does not exist" do
      let(:phone) { Phone.create(computer: computer) }
      it { is_expected.to be false }
    end
  end

  describe "override_*?" do
    it "is aliased to override_*" do
      phone = Phone.new
      expect(phone.method(:override_manufacturer)).
        to eq phone.method(:override_manufacturer?)
    end
  end

end
