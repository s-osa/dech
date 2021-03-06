# coding: utf-8
require 'net/ftp'
require 'dech/yahoo/csv'

module Dech
  class Yahoo
    class FTP
      DEFAULT_HOST = "yjftp.yahoofs.jp"
      DEFAULT_PATH = "/data_spy.csv"

      attr_accessor :products, :username, :host, :path

      def initialize(args={})
        @products = args[:products] || []
        @username = args[:username]
        @password = args[:password]
        @host     = args[:host] || DEFAULT_HOST
        @path     = args[:path] || DEFAULT_PATH
      end

      def csv
        Dech::Yahoo::CSV.new(@products)
      end

      def ready?
        ftp_connection{|ftp| !ftp.nlst(File.dirname(@path)).include?(@path) }
      end

      def upload!
        ftp_connection{|ftp| ftp.storlines("STOR #{@path}", csv) }
        true
      end

      def upload
        ready? && upload!
      end

      private

      def ftp_connection
         Net::FTP.open(@host, @username, @password) do |ftp|
           ftp.passive = true
           yield(ftp)
         end
      end
    end
  end
end
