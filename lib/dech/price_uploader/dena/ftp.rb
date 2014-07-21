# coding: utf-8

require 'dech/csvio'
require 'net/ftp'

module Dech
  module PriceUploader
    module Dena
      class FTP
        HEADERS = %w(Code exhibittype Price KtaiPrice)

        attr_accessor :username, :host, :path

        def initialize(args={})
          @products = args[:products] || []
          @username = args[:username]
          @password = args[:password]
          @host     = args[:host] || "bcmaster1.dena.ne.jp"
          @path     = args[:path] || "/data.csv"
        end

        def ready?
          true
        end

        def csv
          Dech::CSVIO.generate do |csv|
            csv << HEADERS
            @products.each do |product|
              csv << [product[:id], "MX", product[:price], product[:price]]
            end
          end
        end

        def save_csv_as(filename)
          FileUtils.mkdir_p(File.dirname(filename))
          File.open(filename, "w:windows-31j") do |file|
            file << csv.string
          end
        end

        def upload!
          ftp_connection{|ftp| ftp.storlines("STOR #{@path}", csv) }
          true
        end

        def upload
          ready? && upload!
        end

        private

        def ftp_connection(&block)
          ftp = Net::FTP.new
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
