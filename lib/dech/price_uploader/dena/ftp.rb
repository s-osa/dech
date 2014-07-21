# coding: utf-8

require 'dech/csvio'
require 'net/ftp'

module Dech
  module PriceUploader
    module Dena
      class FTP
        HEADERS = %w(Code exhibittype KtaiPrice)

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

        def csv
          Dech::CSVIO.generate do |csv|
            csv << HEADERS
            @products.each do |product|
              csv << [product[:id].to_s.downcase, "MX", product[:price]]
            end
          end
        end

        def save_csv_as(filename)
          FileUtils.mkdir_p(File.dirname(filename))
          File.open(filename, "w:windows-31j") do |file|
            file << csv.string
          end
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
