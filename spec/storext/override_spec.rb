require 'spec_helper'

describe Storext::Override do

  let(:including_class) do
    klass = Phone
    klass.storext_override(:computer, :data, override_options)
    klass
  end
  let(:including_class_subclass) do
    Class.new(including_class)
  end
  let(:override_options) do
    { ignore_override_if_blank: ignore_override_if_blank }
  end

  describe 'inclusion' do
    it 'does not overwrite storext_options set in the parent' do
      expect(SuperKomputer.new.options).to eq({ some: :options }.to_s)
    end
  end

  describe '.storext_override' do
    let(:ignore_override_if_blank) { true }

    it { expect(including_class.override_options).to eq override_options }

    it "propagates the storext attributes to subclasses" do
      expect(including_class_subclass.storext_definitions)
        .to match(including_class.storext_definitions)
    end
  end

  describe 'override_options' do
    let(:computer) do
      Komputer.create(manufacturer: 'Compaq')
    end
    let(:phone) do
      including_class.create(computer: computer)
    end
    let(:phone_manufacturer) { '' }

    before do
      phone.update_attributes(
        manufacturer: phone_manufacturer,
        override_manufacturer: true,
        manufactured: false,
        override_manufactured: true,
      )
    end

    context 'ignore_override_if_blank is true' do
      let(:ignore_override_if_blank) { true }

      it do
        expect(phone.manufacturer).to eq computer.manufacturer
      end

      it "does not delete keys with false boolean data" do
        expect(phone.manufactured).to eq false
      end
    end

    context 'ignore_override_if_blank is false' do
      let(:ignore_override_if_blank) { false }

      it do
        expect(phone.manufacturer).to eq phone_manufacturer
      end

      it "does not delete keys with false boolean data" do
        expect(phone.manufactured).to eq false
      end
    end
  end

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

  it "can inherit attribute from any ancestor provided in :class option" do
    computer = Komputer.create(manufacturer: "Dell")
    phone = Phone.create(computer: computer, manufacturer: "Compaq")
    sim_card = SimCard.create(phone: phone)
    expect(sim_card.manufacturer).to eq "Dell"
  end

  it "can override attribute from any ancestor provided in the :class option" do
    computer = Komputer.create(manufacturer: "Dell")
    phone = Phone.create(computer: computer, manufacturer: "Compaq")
    sim_card = SimCard.create(phone: phone, manufacturer: "Verizon")
    expect(sim_card.manufacturer).to eq "Verizon"
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
