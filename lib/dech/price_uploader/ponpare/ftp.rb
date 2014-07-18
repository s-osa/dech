require "net/ftp"

module Dech
  module PriceUploader
    module Ponpare
      class FTP
        attr_accessor :username, :host, :path

        def initialize(args={})
          @products = args[:products] || []
          @username = args[:username]
          @password = args[:password]
          @host     = args[:host] || "ftps.ponparemall.com"
          @path     = args[:path] || "/item.csv"
        end

        def ready?
          Net::FTP.open(@host, @username, @password){|ftp| ftp.list(path).empty? }
        end
      end
    end
  end
end
