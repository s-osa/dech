# coding: utf-8
require "spec_helper"

describe Dech::HashKeyMapper do
  describe "class methods" do
    describe ".map" do
      it "should call #{described_class}#map" do
        hash = {}
        mapping = {}

        mapper = double("mapper")
        expect(mapper).to receive(:map)
        expect(described_class).to receive(:new).with(hash, mapping).and_return(mapper)

        described_class.map(hash, mapping)
      end
    end
  end

  describe "initialize" do
    subject{ described_class.new }
    it { is_expected.to be_an_instance_of(described_class) }
  end

  describe "#map" do
    context "1 key to 1 key" do
      hash    = {foo: "foo", bar: "bar", fizz: "fizz"}
      mapping = {foo: "FOO", fizz: "FIZZ"}

      subject{ described_class.new(hash, mapping).map }
      it "should rename a key" do
        is_expected.to eq({"FOO" => "foo", bar: "bar", "FIZZ" => "fizz"})
      end
    end

    context "1 key to n keys" do
      hash    = {foo: "foo", bar: "bar", fizz: "fizz"}
      mapping = {foo: ["FOO", "Foo"], fizz: "FIZZ"}

      subject{ described_class.new(hash, mapping).map }
      it "should remove a old key and add new keys" do
        is_expected.to eq({"FOO" => "foo", "Foo" => "foo", bar: "bar", "FIZZ" => "fizz"})
      end
    end
  end
end
