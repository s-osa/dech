# coding: utf-8

require "spec_helper"

describe Dech::PriceUploader::Ponpare::FTPS do
  let(:dech) {
    Dech::PriceUploader::Ponpare::FTPS.new(
      products: [{id: "PRODUCT-CODE", price: 9800}],
      username: "username",
      password: "password",
      host:     "example.com"
    )
  }

  let(:ftps) {
    ftps = double("ftps")
    allow(ftps).to receive(:passive=)
    allow(ftps).to receive(:ssl_context=)
    allow(ftps).to receive(:connect)
    allow(ftps).to receive(:login)
    allow(ftps).to receive(:close)
    ftps
  }

  describe "initialize" do
    context "given no args" do
      it "should create an instance successfully" do
        expect(dech).to be_an_instance_of(Dech::PriceUploader::Ponpare::FTPS)
      end
    end

    context "given some args" do
      it "should create an instance successfully" do
        expect(dech).to be_an_instance_of(Dech::PriceUploader::Ponpare::FTPS)
      end
    end
  end

  describe "#ready?" do
    context "some files in the server" do
      before do
        expect(ftps).to receive(:nlst).and_return([dech.path])
        expect(DoubleBagFTPS).to receive(:new).and_return(ftps)
      end

      it "should be false" do
        expect(dech.ready?).to be false
      end
    end

    context "any files in the server" do
      before do
        expect(ftps).to receive(:nlst).and_return([])
        expect(DoubleBagFTPS).to receive(:new).and_return(ftps)
      end

      it "should be true" do
        expect(dech.ready?).to be true
      end
    end
  end

  describe "#csv" do
    headers = {
      "コントロールカラム"    => /\Au\Z/,
      "商品管理ID（商品URL）" => String,
      "販売価格"              => /\d+/
    }

    describe "headers" do
      let(:csv){ CSV.new(dech.csv, headers: true) }

      headers.each_key.map{|h| h.encode(Encoding::Windows_31J) }.each do |header|
        it "should have '#{header}' header" do
          csv.readlines
          expect(csv.headers).to be_include(header)
        end
      end
    end

    describe "columns" do
      let(:csv){ CSV.new(dech.csv, headers: true).read }

      headers.each do |header, type|
        it "should have #{type} in '#{header}'" do
          expect(csv[header.encode(Encoding::Windows_31J)]).to be_all{|c| type === c }
        end
      end
    end

    describe "encoding" do
      let(:io){ dech.csv }

      it "should have windows-31j as external_encoding" do
        expect(io.external_encoding).to eq(Encoding::Windows_31J)
      end
    end
  end

  describe "#save_csv_as" do
    let(:filename){ "tmp/#{Time.now.strftime("%Y%m%d_%H%M%S_%N")}.csv" }

    it "should save CSV file as given name" do
      dech.save_csv_as(filename)
      expect(Dir.glob("tmp/*")).to be_include(filename)
    end

    it "should save CSV file in Shift_JIS" do
      dech.save_csv_as(filename)
      CSV.open(filename, "r:windows-31j:utf-8", headers: true) do |csv|
        expect{csv.readlines}.not_to raise_error
        expect(csv.headers).to eq(Dech::PriceUploader::Ponpare::FTPS::HEADERS)
      end
    end
  end

  describe "#upload" do
    context "server is ready" do
      before do
        allow(ftps).to receive(:nlst).and_return([])
        expect(ftps).to receive(:storlines)
        expect(DoubleBagFTPS).to receive(:new).and_return(ftps).at_least(:once)
      end

      it "should upload CSV file to the path on FTPS server" do
        expect(dech.upload).to be true
      end
    end

    context "server is not ready" do
      before do
        allow(ftps).to receive(:nlst).and_return([dech.path])
        expect(DoubleBagFTPS).to receive(:new).and_return(ftps)
      end

      it "should not upload CSV file to the path on FTPS server" do
        expect(dech.upload).to be false
      end
    end
  end
end
