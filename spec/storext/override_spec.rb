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

  context "override_* is false" do
    it "removes the manufacturer key so the overrider defaults to the parent" do
      computer = Komputer.create(manufacturer: "Dell")
      phone = Phone.create(computer: computer, manufacturer: "Compaq")

      phone.update_attributes({
        override_manufacturer: false,
        manufacturer: "Doesn't matter",
      })

      expect(phone.data).to_not have_key(:manufacturer)
      expect(phone.manufacturer).to eq "Dell"
    end

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
