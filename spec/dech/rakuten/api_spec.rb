require "spec_helper"
require "webmock/rspec"

describe Dech::Rakuten::API do
  let(:api) {
    described_class.new(
      products: [{id: "PRODUCT-CODE", price: 9800, "item_name" => 'PRODUCT-NAME'}],
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
      expect(api.send(:formatted_products)).to eq [{'item_url'=> 'PRODUCT-CODE', 'item_price'=> 9800, 'item_name' => 'PRODUCT-NAME'}]
    end
  end

  describe "#ready?" do
    subject {api.ready?}
    it { is_expected.to be_truthy }
  end

  describe "#upload!" do
    let!(:stub){stub_request(:post, "https://api.rms.rakuten.co.jp/es/1.0/item/update")}

    it "should raise Error" do
      expect{api.upload!}.to raise_error
    end

    it "should access API" do
      api.upload! rescue true
      expect(stub).to have_been_made
    end
  end

  describe "#upload" do
    before do
      stub_request(:post, "https://api.rms.rakuten.co.jp/es/1.0/item/update")
      api.upload
    end

    subject {a_request(:post, "https://api.rms.rakuten.co.jp/es/1.0/item/update")}
    it("should access API") {is_expected.to have_been_made}
  end
end
