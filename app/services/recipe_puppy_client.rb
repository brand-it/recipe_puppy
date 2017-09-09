# frozen_string_literal: true

require 'recipe_puppy_client/config'
module RecipePuppyClient
  def self.configuration
    @configuration ||= RecipePuppyClient::Config.new
  end

  def self.configure
    yield configuration
    configuration
  end
end
require 'recipe_puppy_client/base'
