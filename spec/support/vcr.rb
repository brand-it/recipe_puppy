# frozen_string_literal: true

require 'vcr'


VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  # c.debug_logger =  File.open("#{Rails.root}/log/test.log")
  c.ignore_request do |request|
    URI(request.uri).host =~ /127.0.0.1/ || URI(request.uri).host =~ /localhost/
  end
end
