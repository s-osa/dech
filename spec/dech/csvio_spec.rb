# coding: utf-8

require "spec_helper"

describe Dech::CSVIO do
  describe ".generate" do
    describe "class" do
      it "should return an instance of StringIO" do
        actual = Dech::CSVIO.generate
        expect(actual).to be_is_a(StringIO)
      end

      it "should return an instance of Dech::CSVIO" do
        actual = Dech::CSVIO.generate
        expect(actual).to be_is_a(Dech::CSVIO)
      end
    end

    describe "encoding" do
      it "should have windows-31j external_encoding as default" do
        actual = Dech::CSVIO.generate
        expect(actual.external_encoding).to eq(Encoding::Windows_31J)
      end

      it "should have given external_encoding" do
        actual = Dech::CSVIO.generate(encoding: Encoding::UTF_8)
        expect(actual.external_encoding).to eq(Encoding::UTF_8)
      end
    end

    describe "headers" do
      before do
        @headers = %w(a b c d e)
        io = Dech::CSVIO.generate{|csv| csv << @headers }
        @csv = CSV.new(io, headers: true)
        @csv.readlines
      end

      it "should be able to set headers" do
        expect(@csv.headers).to eq(@headers)
      end
    end
  end
end
