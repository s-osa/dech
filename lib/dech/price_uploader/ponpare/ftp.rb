module Dech
  module PriceUploader
    module Ponpare
      class FTP
        def initialize(args={})
          @products = args[:products] || []
          @username = args[:username]
          @password = args[:password]
          @host     = args[:host] || "ftps.ponparemall.com"
          @path     = args[:path] || "/"
        end
      end
    end
  end
end
