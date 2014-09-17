require 'rms_web_service'

module Dech
  class Rakuten
    class API
      HEADER_MAPPINGS = {
        id:    "item_url",
        price: "item_price"
      }

      def initialize(args)
        @client = ::RmsWebService::Client::Item.new(
          :service_secret => args[:service_secret],
          :license_key => args[:license_key],
          :endpoint => args[:endpoint]
        )
        @products = args[:products]
      end

      def upload
        upload! rescue false
        true
      end

      def upload!
        formatted_products.each do |product|
          item = @client.update(product)
          raise "#{item.errors}" unless item.success?
        end
      end

      def ready?
        true
      end

      private

      def formatted_products
        @products.map{|product| Dech::HashKeyMapper.map(product, HEADER_MAPPINGS) }
      end
    end
  end
end
