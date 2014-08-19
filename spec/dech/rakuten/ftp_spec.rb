# coding: utf-8

require "spec_helper"

describe Dech::Rakuten::FTP do
  let(:ftp) {
    described_class.new(
      products: [{id: "PRODUCT-CODE", price: 9800}],
      username: "username",
      password: "password",
      host:     "example.com"
    )
  }

  let(:net_ftp) {
    net_ftp = double("net_ftp")
    allow(net_ftp).to receive(:passive=)
    allow(net_ftp).to receive(:connect)
    allow(net_ftp).to receive(:login)
    allow(net_ftp).to receive(:close)
    expect(Net::FTP).to receive(:new).and_return(net_ftp)
    net_ftp
  }

  describe "initialize" do
    subject { ftp }
    it { is_expected.to be_an_instance_of(described_class) }
  end

  describe "#csv" do
    subject { ftp.csv }
    it { is_expected.to be_an_instance_of(Dech::Rakuten::CSV) }
  end

  describe "#ready?" do
    subject { ftp.ready? }

    context "CSV file exists in FTP server" do
      before { expect(net_ftp).to receive(:nlst).and_return([ftp.path]) }
      it { is_expected.to be false }
    end

    context "CSV file does not exist in FTP server" do
      before { expect(net_ftp).to receive(:nlst).and_return([]) }
      it { is_expected.to be true }
    end
  end

  describe "#upload!" do
    subject{ lambda{ ftp.upload! } }

    it "should upload CSV file to the path on FTP server" do
      expect(net_ftp).to receive(:storlines)
      subject.call
    end
  end

  describe "#upload" do
    subject{ lambda{ ftp.upload } }

    context "FTP server is ready" do
      it "should call #upload!" do
        expect(ftp).to receive(:ready?).and_return(true)
        expect(ftp).to receive(:upload!).and_return(true)
        subject.call
      end
    end

    context "FTP server is not ready" do
      it "should not call #upload!" do
        expect(ftp).to receive(:ready?).and_return(false)
        expect(ftp).not_to receive(:upload!)
        subject.call
      end
    end
  end
end
