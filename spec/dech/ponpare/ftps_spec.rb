# coding: utf-8

require "spec_helper"

describe Dech::Ponpare::FTPS do
  let(:ftp) {
    described_class.new(
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
    expect(DoubleBagFTPS).to receive(:new).and_return(ftps)
    ftps
  }

  describe "initialize" do
    subject { ftp }
    it { is_expected.to be_an_instance_of(described_class) }
  end

  describe "#csv" do
    subject { ftp.csv }
    it { is_expected.to be_an_instance_of(Dech::Ponpare::CSV) }
  end

  describe "#ready?" do
    subject { ftp.ready? }

    context "CSV file exists in FTPS server" do
      before { expect(ftps).to receive(:nlst).and_return([ftp.path]) }
      it { is_expected.to be false }
    end

    context "CSV file does not exist in FTPS server" do
      before { expect(ftps).to receive(:nlst).and_return([]) }
      it { is_expected.to be true }
    end
  end

  describe "#upload!" do
    subject{ lambda{ ftp.upload! } }

    it "should upload CSV file to the path on FTPS server" do
      expect(ftps).to receive(:storlines)
      subject.call
    end
  end

  describe "#upload" do
    subject{ lambda{ ftp.upload } }

    context "FTPS server is ready" do
      it "should call #upload!" do
        expect(ftp).to receive(:ready?).and_return(true)
        expect(ftp).to receive(:upload!).and_return(true)
        subject.call
      end
    end

    context "FTPS server is not ready" do
      it "should not call #upload!" do
        expect(ftp).to receive(:ready?).and_return(false)
        expect(ftp).not_to receive(:upload!)
        subject.call
      end
    end
  end
end
