# coding: utf-8
require 'net/ftp'
require 'dech/dena/csv'

module Dech
  class Dena
    class FTP
      DEFAULT_HOST = "bcmaster1.dena.ne.jp"
      DEFAULT_PATH = "/data.csv"

      attr_accessor :products, :username, :host, :path

      def initialize(args={})
        @products = args[:products] || []
        @username = args[:username]
        @password = args[:password]
        @host     = args[:host] || DEFAULT_HOST
        @path     = args[:path] || DEFAULT_PATH
      end

      def csv
        Dech::Dena::CSV.new(@products)
      end

      def ready?
        true
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
