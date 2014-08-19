# coding: utf-8

require 'csv'
require 'stringio'

module Dech
  class CSV < StringIO
    DEFAULT_ENCODING = Encoding::Windows_31J

    HEADER_MAPPINGS  = {}
    REQUIRED_HEADERS = []
    STATIC_COLUMNS   = {}

    def initialize(array, args={})
      @array = array
      @option = {}
      @option[:headers]  = args[:headers] != false
      @option[:encoding] = args[:encoding] || DEFAULT_ENCODING
      super(csv_string)
    end

    def headers
      @option[:headers] ? @array.first : nil
    end

    def save_as(path)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, [:w, @option[:encoding].name].join(":")){|file| file << csv_string }
    end

    def to_a
      @array
    end

    def to_s
      csv_string
    end

    private

    def csv_string
      ::CSV.generate{|csv| @array.each{|row| csv << row } }.encode(@option[:encoding])
    end
  end
end
