require "spec_helper"

describe Dech::Rakuten::API do
  let(:api) {
    described_class.new(
      products: [{id: "PRODUCT-CODE", price: 9800}],
      service_secret: "service_secret",
      license_key: "license_key"
    )
  }

  describe "initialize" do
    subject {api}
    it { is_expected.to be_a Dech::Rakuten::API}
  end

  describe "#formatted_products" do
    it 'should return formatted parameters' do
      expect(api.send(:formatted_products)).to eq [{'item_url'=> 'PRODUCT-CODE', 'item_price'=> 9800}]
    end
  end

  describe "#ready?" do
    subject {api.ready?}
    it { is_expected.to be_truthy }
  end
end
