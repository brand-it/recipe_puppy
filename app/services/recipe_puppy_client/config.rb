# frozen_string_literal: true

module RecipePuppyClient
  class Config
    attr_accessor :uri, :api_key, :verify_ssl
    def initialize
      self.uri = 'http://www.recipepuppy.com/api'
      self.verify_ssl = true
    end
  end
end
