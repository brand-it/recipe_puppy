# frozen_string_literal: true

require 'httparty'

module RecipePuppyClient
  class NotFound < StandardError; end
  class AccessDenied < StandardError; end
  class InternalServerError < StandardError; end
  class Redirect < StandardError; end

  class Base
    include HTTParty

    # header defaults that don't change
    headers 'Content-Type' => 'application/json'
    headers 'Accept' => 'application/json'

    def self.setup
      Base.base_uri(RecipePuppyClient.configuration.uri.to_s)
      Base.default_options.update(verify: RecipePuppyClient.configuration.verify_ssl)
    end

    def self.get(path, options = {})
      setup
      options[:query][:key] = RecipePuppyClient.configuration.api_key
      results = super(path, options.merge(format: :json))
      verify_response(results)
      objectize(results)
    end

    def self.headers
      super.merge(
        'key' => RecipePuppyClient.configuration.api_key
      )
    end

    # Don't need a post in this case but here it is anyway
    # def post(path, options = {})
    #   Base.post URI.join(RecipePuppyClient.configuration.host, path).path, options
    # end
    def self.objectize(parsed_response)
      return parsed_response if name == 'RecipePuppyClient::Base'
      new(parsed_response)
    end

    def self.verify_response(results) # rubocop:disable AbcSize, MethodLength, CyclomaticComplexity
      case results.response.code.to_i
      when 401
        raise RecipePuppyClient::AccessDenied, "#{results.request.last_uri}\n#{results.parsed_response}"
      when 404
        raise RecipePuppyClient::NotFound, "Record Not Found\n#{results.request.last_uri}"
      when 200
        true
      when 302
        raise(
          RecipePuppyClient::Redirect,
          "Some how we got redirected but I don't know how to handle this\n"\
          "#{results.request.last_uri} #{results.parsed_response}\n#{results.request.query}"
        )
      else
        extra_info = "\n#{results.request.inspect}" if Rails.env.development? || Rails.env.test?
        raise(
          RecipePuppyClient::InternalServerError,
          "(#{results.response.code}) Unknow Response\n#{results.request.last_uri}\n#{results.parsed_response}#{extra_info}"
        )
      end
    end
  end
end
