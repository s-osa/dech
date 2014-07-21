# coding: utf-8

require "net/ftp"
require "csv"

module Dech
  module PriceUploader
    module Dena
      class FTP
        attr_accessor :username, :host, :path

        def initialize(args={})
          @products = args[:products] || []
          @username = args[:username]
          @password = args[:password]
          @host     = args[:host] || "bcmaster1.dena.ne.jp"
          @path     = args[:path] || "/data.csv"
        end

        def ready?
          ftp_connection{|ftp| !ftp.nlst(File.dirname(@path)).include?(@path) }
        end

        private

        def ftp_connection(&block)
          ftp = Net::FTP.new
          ftp.passive = true
          ftp.connect(@host)
          ftp.login(@username, @password)

          yield(ftp)
        ensure
          ftp.close
        end
      end
    end
  end
end
