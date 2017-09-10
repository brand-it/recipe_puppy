# frozen_string_literal: true

module RecipePuppyClient
  class Search < RecipePuppyClient::Base
    attr_accessor :recipes
    def initialize(results)
      if results
        self.recipes = results.parsed_response['results']
      else
        self.recipes = []
      end
    end

    def self.where(query: nil, page: 1, ingredients: [])
      query = { q: query, p: page, i: ingredients }
      query[:i] = ingredients.join(',')
      query.reject! { |_k, v| v.nil? || v.size.zero? }
      query[:page] ||= 1 # default page to one if not provided. THis is just a fail safe
      get('/', query: query)
    rescue RecipePuppyClient::InternalServerError, JSON::ParserError => exception
      Rails.logger.warn(exception.message)
      RecipePuppyClient::Search.new(nil)
    end
  end
end
