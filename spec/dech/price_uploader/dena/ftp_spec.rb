# coding: utf-8

require "spec_helper"

describe Dech::PriceUploader::Dena::FTP do
  let(:dech) {
    Dech::PriceUploader::Dena::FTP.new(
      products: [{id: "PRODUCT-CODE", price: 9800}],
      username: "username",
      password: "password",
      host:     "example.com"
    )
  }

  let(:ftp) {
    ftp = double("ftp")
    allow(ftp).to receive(:passive=)
    allow(ftp).to receive(:connect)
    allow(ftp).to receive(:login)
    allow(ftp).to receive(:close)
    ftp
  }

  describe "initialize" do
    context "given no args" do
      it "should create an instance successfully" do
        expect(dech).to be_an_instance_of(Dech::PriceUploader::Dena::FTP)
      end
    end

    context "given some args" do
      it "should create an instance successfully" do
        expect(dech).to be_an_instance_of(Dech::PriceUploader::Dena::FTP)
      end
    end
  end

  describe "#ready?" do
    context "some files in the server" do
      before do
        expect(ftp).to receive(:nlst).and_return([dech.path])
        expect(Net::FTP).to receive(:new).and_return(ftp)
      end

      it "should be false" do
        expect(dech.ready?).to be false
      end
    end

    context "any files in the server" do
      before do
        expect(ftp).to receive(:nlst).and_return([])
        expect(Net::FTP).to receive(:new).and_return(ftp)
      end

      it "should be true" do
        expect(dech.ready?).to be true
      end
    end
  end

end
