# frozen_string_literal: true

module FirstACH
  # This is the base FirstACH exception class. Rescue it if you want to
  # catch any exception that your request might raise.
  class Error < RuntimeError
    attr_accessor :response

    def initialize(response = nil)
      @response = response
    end

    def code
      @response.code
    end

    def text
      @response.text
    end

    def message
      @response.message
    end

    def to_s
      "#{code} #{message}"
    end
  end
end
