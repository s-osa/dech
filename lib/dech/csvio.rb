# coding: utf-8

require 'csv'
require 'stringio'

module Dech
  class CSVIO < StringIO
    class << self
      def generate(args={})
        csv_string = ::CSV.generate{|csv| yield(csv) if block_given? }
        self.new(csv_string.encode(args[:encoding] || Encoding::Windows_31J))
      end
    end
  end
end
