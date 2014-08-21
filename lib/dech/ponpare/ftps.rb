# coding: utf-8
require 'double_bag_ftps'
require 'dech/ponpare/csv'

module Dech
  class Ponpare
    class FTPS
      DEFAULT_HOST = "ftps.ponparemall.com"
      DEFAULT_PATH = "/item.csv"

      attr_accessor :products, :username, :host, :path

      def initialize(args={})
        @products = args[:products] || []
        @username = args[:username]
        @password = args[:password]
        @host     = args[:host] || DEFAULT_HOST
        @path     = args[:path] || DEFAULT_PATH
      end

      def csv
        Dech::Ponpare::CSV.new(@products)
      end

      def ready?
        ftps_connection{|ftps| !ftps.nlst(File.dirname(@path)).include?(@path) }
      end

      def upload!
        ftps_connection{|ftps| ftps.storlines("STOR #{@path}", csv) }
        true
      end

      def upload
        ready? && upload!
      end

      private

      def ftps_connection(&block)
        ftps = DoubleBagFTPS.new
        ftps.passive = true
        ftps.ssl_context = DoubleBagFTPS.create_ssl_context(verify_mode: OpenSSL::SSL::VERIFY_NONE)
        ftps.connect(@host)
        ftps.login(@username, @password)

        yield(ftps)
      ensure
        ftps.close
      end
    end
  end
end
