# coding: utf-8
require 'emmental'
require 'dech/csv'
require 'dech/hash_key_mapper'

module Dech
  class Dena
    class CSV < Dech::CSV
      ENCODING = Encoding::Windows_31J

      HEADER_MAPPINGS = {
        id:    "Code",
        price: ["Price", "KtaiPrice"]
      }

      REQUIRED_HEADERS = [
        "Code",
        "exhibittype"
      ]

      STATIC_COLUMNS = {"exhibittype" => "MX"}

      def initialize(products)
        @products = products
        super(formatted_products)
      end

      def valid?
        validate! rescue false
      end

      def validate!
        translated_products.each do |product|
          REQUIRED_HEADERS.each do |header|
            raise "#{header} is missing in #{product}" unless product.keys.include?(header)
          end
        end
      end

      private

      def formatted_products
        emmental = Emmental.new
        translated_products.each{|product| emmental << product }
        emmental.to_a
      end

      def translated_products
        merged_products.map{|product| Dech::HashKeyMapper.map(product, HEADER_MAPPINGS) }
      end

      def merged_products
        @products.map{|product| STATIC_COLUMNS.merge(product) }
      end
    end
  end
end
