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

end
