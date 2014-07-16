require "spec_helper"

describe Dech::PriceUploader::Ponpare::FTP do
  describe "initialize" do
    context "given no args" do
      it "should create an instance successfully" do
        dech = Dech::PriceUploader::Ponpare::FTP.new
        expect(dech).to be_an_instance_of(Dech::PriceUploader::Ponpare::FTP)
      end
    end

    context "given some args" do
      it "should create an instance successfully" do
        dech = Dech::PriceUploader::Ponpare::FTP.new(products: {}, uri: "")
        expect(dech).to be_an_instance_of(Dech::PriceUploader::Ponpare::FTP)
      end
    end
  end
end
