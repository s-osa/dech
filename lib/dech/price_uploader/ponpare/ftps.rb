# coding: utf-8

require "net/ftp"
require "double_bag_ftps"
require "csv"

module Dech
  module PriceUploader
    module Ponpare
      class FTPS
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
          ftps_connection{|ftps| !ftps.nlst(File.dirname(@path)).include?(@path) }
        end

        def csv
          csv_string = CSV.generate do |csv|
            csv << HEADERS
            @products.each do |product|
              csv << ["u", product[:id].to_s.downcase, product[:price]]
            end
          end

          StringIO.new(csv_string.encode(Encoding::Windows_31J))
        end

        def save_csv_as(filename)
          FileUtils.mkdir_p(File.dirname(filename))
          File.open(filename, "w:windows-31j") do |file|
            file << csv.string
          end
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
end
