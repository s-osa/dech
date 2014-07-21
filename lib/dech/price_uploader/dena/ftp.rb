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
      end
    end
  end
end
