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
end
