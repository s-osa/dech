# coding: utf-8
require "spec_helper"

describe Dech::CSV do
  describe "initialize" do
    describe "class" do
      subject{ Dech::CSV.new([]) }
      it { is_expected.to be_a(StringIO) }
      it { is_expected.to be_an_instance_of(Dech::CSV) }
    end

    describe "options" do
      describe "encoding" do
        context :default do
          subject{ Dech::CSV.new([]).external_encoding }
          it { is_expected.to be(Encoding::Windows_31J) }
        end

        context :given, Encoding::UTF_8 do
          subject{ Dech::CSV.new([], encoding: Encoding::UTF_8).external_encoding }
          it { is_expected.to be(Encoding::UTF_8) }
        end
      end

      describe "headers" do
        array = [[:col1, :col2, :col3], [1, 2, 3]]

        context "default with", array.first do
          subject{ Dech::CSV.new(array).headers }
          it { is_expected.to eq(array.first) }
        end

        context "given false with", array.first do
          subject{ Dech::CSV.new(array, headers: false).headers }
          it { is_expected.to eq(nil) }
        end
      end
    end
  end

  describe "#to_a" do
    array = [[:col1, :col2, :col3], [1, 2, 3]]
    subject{ Dech::CSV.new(array).to_a }

    it { is_expected.to be_an_instance_of(Array) }

    context :given, array do
        it { is_expected.to eq(array) }
    end
  end

  describe "#to_s" do
    array = [[:col1, :col2, :col3], [1, 2, 3]]
    subject{ Dech::CSV.new(array).to_s }

    it { is_expected.to be_an_instance_of(String) }

    context :given, array do
      array.each do |row|
        row.each do |cell|
          it { is_expected.to include(cell.to_s) }
        end
      end
    end
  end

  describe "#save_as(path)" do
    let(:dirname) { "tmp" }
    let(:filename){ "#{Time.now.strftime("%Y%m%d_%H%M%S_%N")}.csv" }
    let(:path)    { File.join(dirname, filename) }
    subject{ lambda{ Dech::CSV.new([]).save_as(path) } }

    it { is_expected.to change{Dir.glob(File.join(dirname, "*")).size}.by(1) }

    describe "saved file" do
      before { subject.call }

      it "should exist" do
        expect(Dir.glob(File.join(dirname, "*"))).to include(path)
      end

      it "should be valid CSV" do
        CSV.open(path, "r:windows-31j:utf-8", headers: true) do |csv|
          expect{csv.readlines}.not_to raise_error
        end
      end
    end

    after do
      files = Dir.glob(File.join(dirname, "*"))
      FileUtils.remove(files)
    end
  end
end
