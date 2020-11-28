require 'time'
require 'json'

module Xon

  class ParserError < StandardError; end

  VERSION = '0.1.0'.freeze
  PREAMBLE = '!:'.freeze

  class << self

    def parse(str)
      init!
      if str.is_a?(String) && str.start_with?(PREAMBLE)
        decode(JSON.parse(str[PREAMBLE.length..-1]))
      else
        JSON.parse(str)
      end
    rescue JSON::ParserError => e
      raise ParserError.new(e.message)
    end

    def generate(data)
      init!
      if special?(data)
        PREAMBLE + JSON.generate(encode(data))
      else
        JSON.generate(data)
      end
    end

    alias :load :parse
    alias :dump :generate

    private

    def decode(obj)
      if obj.is_a?(String)
        type, value = obj.split(":", 2)
        raise ParserError.new("incorrectly formatted string value") if value.nil?
        case type
        when ''
          value
        when 't'
          begin
            Time.parse(value)
          rescue ArgumentError => e
            raise ParserError.new(e.message)
          end
        else
          raise ParserError.new("unknown type in string value")
        end
      elsif obj.is_a?(Array)
        obj.map { |v| decode(v) }
      elsif obj.is_a?(Hash)
        obj.transform_values { |v| decode(v) }
      else
        obj
      end
    end

    def encode(obj)
      if obj.is_a?(String)
        ":#{obj}"
      elsif obj.is_a?(Time) || obj.is_a?(DateTime)
        "t:#{obj.iso8601}"
      elsif obj.is_a?(Array)
        obj.map { |v| encode(v) }
      elsif obj.is_a?(Hash)
        obj.transform_values { |v| encode(v) }
      else
        obj
      end
    end

    def special?(obj)
      if obj.is_a?(Time) || obj.is_a?(DateTime)
        true
      elsif obj.is_a?(Array)
        obj.any? { |v| special?(v) }
      elsif obj.is_a?(Hash)
        obj.values.any? { |v| special?(v) }
      else
        false
      end
    end

    # This initialization of constants is intentionally not done in the body
    # of the module, to not be sensitive to loading order.
    @@inited = false
    def init!
      return if @@inited
      @@inited = true
      # Ignore DateTime gracefully if it is not loaded.
      const_set(:DateTime, defined?(DateTime) ? DateTime : Class.new)
      # Prefer MultiJson if it is loaded.
      const_set(:JSON, defined?(MultiJson) ? MultiJson : JSON)
    end

  end

end
