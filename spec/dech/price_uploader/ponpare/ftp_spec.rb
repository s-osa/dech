require "spec_helper"

describe Dech::PriceUploader::Ponpare::FTP do
  let(:dech) {
    Dech::PriceUploader::Ponpare::FTP.new(
      products: [{id: "PRODUCT-CODE", price: 9800}],
      username: "username",
      password: "password",
      host:     "example.com"
  )
  }

  describe "initialize" do
    context "given no args" do
      it "should create an instance successfully" do
        expect(dech).to be_an_instance_of(Dech::PriceUploader::Ponpare::FTP)
      end
    end

    context "given some args" do
      it "should create an instance successfully" do
        expect(dech).to be_an_instance_of(Dech::PriceUploader::Ponpare::FTP)
      end
    end
  end

  describe "#ready?" do
    context "some files in the server" do
      before do
        ftp = double("ftp")
        allow(ftp).to receive(:list).with(dech.path).and_return([dech.path])
        allow(Net::FTP).to receive(:open).and_yield(ftp)
      end

      it "should be false" do
        expect(dech.ready?).to be false
      end
    end

    context "any files in the server" do
      before do
        ftp = double("ftp")
        allow(ftp).to receive(:list).and_return([])
        allow(Net::FTP).to receive(:open).and_yield(ftp)
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

      headers.each_key do |header|
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
          expect(csv[header]).to be_all{|c| type === c }
        end
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
        expect(csv.headers).to eq(Dech::PriceUploader::Ponpare::FTP::HEADERS)
      end
    end
  end
end
