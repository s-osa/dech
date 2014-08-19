# coding: utf-8
require "spec_helper"

describe Dech::Yahoo::CSV do
  let(:valid_products){
    [
      {id: "ABC-001", price: 12800, "name" => "ProductName1", "path" => "a:b"},
      {id: "xyz-123", price: 9800, "name" => "ProductName2", "path" => "a:b:c"}
    ]
  }

  let(:invalid_products){ [ {price: 12800}, {price: 9800} ] }

  describe "initialize" do
    subject{ Dech::Yahoo::CSV.new(valid_products) }
    it { is_expected.to be_an_instance_of(Dech::Yahoo::CSV) }
    it { is_expected.to be_a(Dech::CSV) }
    it { is_expected.to be_a(StringIO) }
  end

  describe "#valid?" do
    context "with valid columns" do
      subject{ Dech::Yahoo::CSV.new(valid_products) }
      it { is_expected.to be_valid }
    end

    context "with invalid columns" do
      subject{ Dech::Yahoo::CSV.new(invalid_products) }
      it { is_expected.not_to be_valid }
    end
  end

  describe "#validate!" do
    context "valid columns" do
      subject{ lambda{ Dech::Yahoo::CSV.new(valid_products).validate! } }
      it { is_expected.not_to raise_error }
    end

    context "invalid columns" do
      subject{ lambda{ Dech::Yahoo::CSV.new(invalid_products).validate! } }
      it { is_expected.to raise_error }
    end
  end
end
