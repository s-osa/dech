require "net/ftp"
require "csv"

module Dech
  module PriceUploader
    module Ponpare
      class FTP
        HEADERS = %w(コントロールカラム 商品管理ID（商品URL） 販売価格)

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

        def csv
          csv_string = CSV.generate("") do |csv|
            csv << HEADERS
            @products.each do |product|
              csv << ["u", product[:id], product[:price]]
            end
          end

          StringIO.new(csv_string)
        end
      end
    end
  end
end
