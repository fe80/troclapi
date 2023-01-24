# frozen_string_literal: true

require './app/helpers/formats'

#
# This class manage format api endpoint
#
class Troclapi < Sinatra::Base
  helpers FormatsHelpers

  # List all available format
  #
  # @return [Hash]
  #   * success (Boolean)
  #   * available (Array)
  get '/v1/formats' do
    { success: true, available: Trocla::Formats.all }.to_json
  end

  # Test if format is available
  #
  # @yieldparam [String] format Format to test
  #
  # @return [Hash]
  #   * success (Boolean)
  #   * available (Boolean)
  get '/v1/formats/:format' do
    result = format_available(params['format'])
    halt 404, result.to_json unless result[:success]
    result.to_json
  end

  # List all format available for a trocla key
  #
  # @yieldparam [String] key Trocla key
  #
  # @return [Hash]
  #   * success (Boolean)
  #   * available (Array)
  get '/v1/formats/:key/' do
    result = trocla_formats(params['key'])
    error(404, result[:error]) unless result[:success]
    result.to_json
  end

  # Test if format is available for a trocla key
  #
  # @yieldparam [String] key Trocla key
  # @yieldparam [String] format Format to test
  #
  # @return [Hash]
  #   * success (Boolean)
  #   * available (Boolean)
  get '/v1/formats/:key/:format' do
    format = params['format']
    error(404, format('Bad format %s', format)) unless formats?(format)
    result = format_available(format, key: params['key'])
    halt 404, result.to_json unless result[:success]
    result.to_json
  end

  # @deprecated
  post '/v1/formats/' do
    result = []
    (playload['keys'] || []).each do |key|
      result << trocla_formats(key).merge(key: key)
    end
    result.to_json
  end
end
