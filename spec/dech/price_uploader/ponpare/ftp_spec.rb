require "spec_helper"

describe Dech::PriceUploader::Ponpare::FTP do
  let(:dech) {
    Dech::PriceUploader::Ponpare::FTP.new(
      products: {},
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
end
