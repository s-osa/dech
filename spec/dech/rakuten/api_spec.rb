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

  describe "#formatted_products (private)" do
    let(:formatted_products){ [{'item_url'=> 'PRODUCT-CODE', 'item_price'=> 9800, 'item_name' => 'PRODUCT-NAME'}] }
    subject{ api.send(:formatted_products) }
    it{ is_expected.to eq(formatted_products)}
  end

  describe "#ready?" do
    subject {api.ready?}
    it { is_expected.to be true }
  end

  describe "#upload!" do
    let!(:request){stub_request(:post, "https://api.rms.rakuten.co.jp/es/1.0/item/update")}

    it "should access to API" do
      api.upload! rescue true
      expect(request).to have_been_made
    end

    context 'access failer' do
      it "should raise RakuteUploadError" do
        expect{api.upload!}.to raise_error ::RakutenUploadError
      end
    end
  end

  describe "#upload" do
    let!(:request){stub_request(:post, "https://api.rms.rakuten.co.jp/es/1.0/item/update")}
    it 'should access to API' do
      api.upload
      expect(request).to have_been_made
    end
  end
end
