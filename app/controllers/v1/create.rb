# frozen_string_literal: true

require './app/helpers/create'

#
# This class manage create api endpoint
#
class Troclapi < Sinatra::Base
  helpers CreateHelpers

  # Create multiple trocla key with random value
  #
  # @yieldparam [Hash] playload
  #   * keys (Hash) List of key to create
  #   * format (String) Default trocla format (merge for all key)
  #   * **xarg All other parameters are dymanic trocla options (merge for all key)
  # @return [Hash]
  # @see CreateHelpers#create
  #
  post '/v1/create/' do
    result = []

    (playload['keys'] || []).each do |k|
      key = k.delete('key')
      format = (k.delete('format') || playload['format'] || 'plain')
      options = playload.merge(k)

      result << create(key, format, options).merge(key: key)
    end

    result.to_json
  end

  # Create trocla key with random value
  #
  # @yieldparam [String] key Trocla key name
  # @yieldparam [String] format Trocla key format
  # @yieldparam [Hash] playload Dynamic Trocla options
  # @return [Hash]
  #   * value (String)
  #   * success (Boolean)
  #   * format (String)
  # @see CreateHelpers#create
  #
  post '/v1/key/:key/:format' do
    logger.debug format('Create actions with params %s', playload.to_s)

    result = create(params['key'], params['format'], playload)
    error(404, result[:error]) unless result[:success]
    result.to_json
  end
end
