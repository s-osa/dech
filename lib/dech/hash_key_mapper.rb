# coding: utf-8

module Dech
  class HashKeyMapper
    class << self
      def map(hash, mapping)
        new(hash, mapping).map
      end
    end

    def initialize(hash={}, mapping={})
      @hash = hash
      @mapping = mapping
    end

    def map
      new_hash = {}
      @hash.each do |k, v|
        [@mapping[k] || k].flatten.each do |new_key|
          new_hash[new_key] = v
        end
      end
      new_hash
    end
  end
end
