# coding: utf-8
require "spec_helper"

describe Dech::Rakuten::CSV do
  describe "initialize" do
    products = [
      {id: "ABC-001", price: 12800},
      {id: "xyz-123", price: 9800}
    ]

    subject{ Dech::Rakuten::CSV.new(products) }
    it { is_expected.to be_an_instance_of(Dech::Rakuten::CSV) }
    it { is_expected.to be_a(Dech::CSV) }
    it { is_expected.to be_a(StringIO) }

    p Dech::Rakuten::CSV.new(products).to_a
  end

  describe "#valid?" do
    context "with valid columns" do
      products = [
        {id: "ABC-001", price: 12800},
        {id: "xyz-123", price: 9800}
      ]

      subject{ Dech::Rakuten::CSV.new(products) }
      it { is_expected.to be_valid }
    end

    context "with invalid columns" do
      products = [
        {price: 12800},
        {price: 9800}
      ]

      subject{ Dech::Rakuten::CSV.new(products) }
      it { is_expected.not_to be_valid }
    end
  end

  describe "#validate!" do
    context "valid columns" do
      products = [
        {id: "ABC-001", price: 12800},
        {id: "xyz-123", price: 9800}
      ]

      subject{ lambda{ Dech::Rakuten::CSV.new(products).validate! } }
      it { is_expected.not_to raise_error }
    end

    context "invalid columns" do
      products = [
        {price: 12800},
        {price: 9800}
      ]

      subject{ lambda{ Dech::Rakuten::CSV.new(products).validate! } }
      it { is_expected.to raise_error }
    end
  end
end
